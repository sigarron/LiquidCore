
//  HeapObjects.cpp
//  LiquidCoreiOS
//
//  Created by Eric Lange on 5/28/18.
//  Copyright © 2018 LiquidPlayer. All rights reserved.
//

#include "HeapObjects.h"
#include "Isolate.h"

using namespace V82JSC_HeapObject;
using namespace v8;

void V82JSC_HeapObject::GlobalContext::RemoveContextFromIsolate(IsolateImpl *iso, JSGlobalContextRef ctx)
{
    iso->m_global_contexts.erase(ctx);
    iso->m_exec_maps.erase(ctx);
    IsolateImpl::s_context_to_isolate_map.erase(ctx);
}

HeapObject * HeapAllocator::Alloc(IsolateImpl *isolate, const BaseMap *map, uint32_t size)
{
    internal::Heap *heap = reinterpret_cast<internal::Isolate*>(isolate)->heap();
    HeapImpl *heapimpl = reinterpret_cast<HeapImpl*>(heap);
    HeapAllocator *chunk = static_cast<HeapAllocator*>(heapimpl->m_heap_top);
    void *alloc = nullptr;
    int index = 0;
    int pos = 0;
    
    assert(map || size > 0);
    if (size == 0) {
        size = map->size;
    }
    assert(size <= ReserveSize(size));
    uint32_t slots = (size <= (HEAP_SLOT_SIZE>>1)) ? 1 : 1 << (LogReserveSize(size) - HEAP_SLOT_SIZE_LOG);
    assert(slots > 0);
    uint32_t actual_used_slots = ((size - 1) / HEAP_SLOT_SIZE) + 1;

    while (!alloc) {
        if (chunk) {
            pos = 0;
            int log = LogReserveSize(size) - HEAP_SLOT_SIZE_LOG;
            if (log < HEAP_SMALL_SPACE_LOG) {
                Transform xform = transform(slots);
                for (index=chunk->info.m_small_indicies[log];
                     index>=0 && (pos = xform(chunk->alloc_map[index])) == 0;
                     --index);
                if (pos == 0) {
                    for (index=HEAP_BLOCKS-1;
                         index>chunk->info.m_small_indicies[log] && (pos = xform(chunk->alloc_map[index])) == 0;
                         --index);
                }
                if (pos) {
                    int slot = (index * 64) + (pos-1);
                    assert(slot < HEAP_SLOTS);
                    alloc = reinterpret_cast<void*>(reinterpret_cast<intptr_t>(chunk) +
                                                    slot * HEAP_SLOT_SIZE);
                    assert(alloc > chunk && alloc < (void*)(reinterpret_cast<intptr_t>(chunk) + HEAP_ALIGNMENT));
                    uint64_t mask = (((uint64_t)1<<actual_used_slots)-1) << (pos-1);
                    assert((chunk->alloc_map[index] & mask) == 0);
                    chunk->alloc_map[index] |= mask;
                    chunk->info.m_small_indicies[log] = index;
                }
            } else {
                int blocks_needed = (((int)size-1) / HEAP_BLOCK_SIZE) + 1;
                int count = 0;
                for (index = chunk->info.m_large_index;
                     count < blocks_needed && index < HEAP_BLOCKS;
                     ++index) {
                    
                    if (chunk->alloc_map[index] == 0) count++;
                    else count = 0;
                }
                if (count < blocks_needed) {
                    count = 0;
                    for (index = 0;
                         count < blocks_needed && index < chunk->info.m_large_index;
                         ++index) {
                        
                        if (chunk->alloc_map[index] == 0) count++;
                        else count = 0;
                    }
                }
                if (count == blocks_needed) {
                    int slot = (index * 64);
                    alloc = reinterpret_cast<void*>(reinterpret_cast<intptr_t>(chunk) +
                                                    (slot * HEAP_SLOT_SIZE));
                    for (int i=0; i<blocks_needed; i++) {
                        uint64_t mask = ~0;
                        if (actual_used_slots < 64) {
                            mask = (((uint64_t)1<<actual_used_slots)-1) << (pos-1);
                            actual_used_slots = 0;
                        } else {
                            actual_used_slots -= 64;
                        }
                        chunk->alloc_map[index-i-1] = mask;
                    }
                    chunk->info.m_large_index = index;
                }
            }
            if (!alloc)
                chunk = static_cast<HeapAllocator*>(chunk->next_chunk());
        }
        
        if (!alloc && !chunk) {
            void *ptr;
            posix_memalign(&ptr, kAlignment, kAlignment);
            
            chunk = (HeapAllocator *)ptr;
            // Reserve first HEAP_RESERVED_SLOTS slots
            memset(chunk->alloc_map, 0xff, HEAP_RESERVED_SLOTS / 8);
            // Clear the rest of reserved space
            memset(reinterpret_cast<void*>(reinterpret_cast<uintptr_t>(chunk->alloc_map) + (HEAP_RESERVED_SLOTS / 8)),
                   0, HEAP_ALLOC_MAP_SIZE * 2 - (HEAP_RESERVED_SLOTS / 8));
            for (int i=0; i<HEAP_SMALL_SPACE_LOG; i++)
                chunk->info.m_small_indicies[i] = HEAP_BLOCKS-1;
            chunk->info.m_large_index = 0;

            chunk->Initialize(heap, reinterpret_cast<internal::Address>(chunk),
                              kAlignment, reinterpret_cast<internal::Address>(chunk), reinterpret_cast<internal::Address>(chunk) - 1,
                              internal::Executability::NOT_EXECUTABLE, nullptr, nullptr);
        } else {
            if (!alloc) {
                // Reset indicies
                for (int i=0; i<HEAP_SMALL_SPACE_LOG; i++)
                    chunk->info.m_small_indicies[i] = HEAP_BLOCKS-1;
                chunk->info.m_large_index = 0;
            }
        }
        
        assert(alloc || chunk);
    }
    
    memset(alloc, 0, size);

    HeapObject * o = reinterpret_cast<HeapObject*>(alloc);

    if (!map) {
        // We are a map.  Point to ourselves
        map = reinterpret_cast<BaseMap*>(o);
    }
    o->m_map = reinterpret_cast<internal::Map*>(reinterpret_cast<intptr_t>(map) + internal::kHeapObjectTag);

    return o;
}

int HeapAllocator::Deallocate(HeapObject *obj, CanonicalHandles& handles, WeakHandles& weak,
                              std::vector<v8::internal::SecondPassCallback>& callbacks)
{
    intptr_t addr = reinterpret_cast<intptr_t>(obj);
    intptr_t chunk_addr = addr & ~(HEAP_ALIGNMENT - 1);
    HeapAllocator *chunk = reinterpret_cast<HeapAllocator*>(chunk_addr);
    IsolateImpl* iso = obj->GetIsolate();

    // If there are any weak handles, perform callbacks now before we blow it away
    internal::Object *h = ToHeapPointer(obj);
    if (weak.count(h)) {
        for (auto i=weak[h].begin(); i != weak[h].end(); ++i) {
            iso->weakObjectCleared(*i, callbacks);
        }
    }
    
    int freed = ((BaseMap*)FromHeapPointer(obj->m_map))->dtor(obj, handles, weak, callbacks);
    int slot = (int) (addr - chunk_addr) / HEAP_SLOT_SIZE;
    int index = slot / 64;
    int pos = slot % 64;
    int size = 0;
    BaseMap* map = (BaseMap*) FromHeapPointer(obj->m_map);
    if (map == iso->m_fixed_array_map) {
        FixedArray *fa = static_cast<FixedArray*>(obj);
        size = sizeof(FixedArray) + fa->m_size * sizeof(internal::Object*);
    } else {
        size = map->size;
    }
    uint32_t actual_used_slots = ((size - 1) / HEAP_SLOT_SIZE) + 1;
    for (uint32_t i = 0; i < actual_used_slots; i++) {
        uint64_t mask = (uint64_t)1 << pos;
        chunk->alloc_map[index] &= ~mask;
        if (++pos > 63) {
            pos = 0;
            index++;
        }
    }
    freed += actual_used_slots * HEAP_SLOT_SIZE;
    return freed;
}

bool HeapAllocator::CollectGarbage(v8::internal::IsolateImpl *iso)
{
    HandleScope scope(reinterpret_cast<Isolate*>(iso));
    // References to heap objects are stored in the following places:
    // 1. The current HandleScope
    // 2. The global handle table
    // 3. Elements in a FixedArray
    //
    // The first pointer in each HeapObject is the map, which is also a heap object pointer.  However,
    // maps are forever, so they will be skipped by the garbage collector.  We need to keep track of this
    // if we happen to decide to implement HeapObject relocation.
    //
    // There shouldn't be any other non-transient references.  We have to also be careful not to collect
    // garbage while inside of a callback, as transient references may exist
    if (iso->m_callback_depth) {
        iso->m_pending_garbage_collection = true;
        return false;
    }
    iso->m_pending_garbage_collection = false;
    
    CanonicalHandles canonical_handles;
    WeakHandles weak_handles;
    std::vector<internal::SecondPassCallback> second_pass_callbacks;
    
    // 1. Walk through local handles and add to our canonical list
    iso->GetActiveLocalHandles(canonical_handles);
    
    // 2. Walk through global handles (separating out weak references)
    iso->getGlobalHandles(canonical_handles, weak_handles);
    
    // 3. Walk through the heap and capture all non-map references.  If we happen along a FixedArray, also
    //    add its elements to the canonical handle list
    internal::Heap *heap = reinterpret_cast<internal::Isolate*>(iso)->heap();
    HeapImpl *heapimpl = reinterpret_cast<HeapImpl*>(heap);
    HeapAllocator *chunk = static_cast<HeapAllocator*>(heapimpl->m_heap_top);

    std::vector<HeapObject*> allocated;
    while (chunk) {
        int slot = HEAP_RESERVED_SLOTS;
        while (slot < HEAP_SLOTS) {
            int index = slot / 64;
            int pos = slot % 64;
            uint64_t mask = (uint64_t)1 << pos;
            if (chunk->alloc_map[index] & mask) {
                intptr_t addr = reinterpret_cast<intptr_t>(chunk) + (index*64 + pos)*HEAP_SLOT_SIZE;
                HeapObject *obj = reinterpret_cast<HeapObject*>(addr);
                // Ignore maps
                int size = 0;
                if (obj->m_map != ToHeapPointer(obj)) {
                    BaseMap* map = (BaseMap*) FromHeapPointer(obj->m_map);
                    if (map == iso->m_fixed_array_map) {
                        FixedArray *fa = static_cast<FixedArray*>(obj);
                        size = sizeof(FixedArray) + fa->m_size * sizeof(internal::Object*);
                        for (int j=0; j<fa->m_size; j++) {
                            if (fa->m_elements[j]->IsHeapObject()) {
                                int count = canonical_handles.count(fa->m_elements[j]) ? canonical_handles[fa->m_elements[j]] : 0;
                                canonical_handles[fa->m_elements[j]] = count + 1;
                            }
                        }
                    } else {
                        size = map->size;
                    }
                    allocated.push_back(obj);
                } else {
                    size = sizeof(BaseMap);
                }
                uint32_t actual_used_slots = ((size - 1) / HEAP_SLOT_SIZE) + 1;
                slot += actual_used_slots;
            } else {
                slot++;
            }
        }
        chunk = static_cast<HeapAllocator*>(chunk->next_chunk());
    }
    // Now we have a list of all the allocated memory locations ('allocated') and a map
    // of those locations that are actually in use ('canonical_handles').
    // We will walk through the 'allocated' list, and if it is not referenced in 'canonical_handles',
    // we will call its destructor and deallocate its memory.
    // The destructors may then trigger further deallocations.
    int freed = 0;
    int freed_chunks = 0;
    int used_chunks = 0;

    for (auto it = allocated.begin(); it != allocated.end(); ++it) {
        if (canonical_handles.count(ToHeapPointer(*it)) == 0) {
            freed += Deallocate(*it, canonical_handles, weak_handles, second_pass_callbacks);
        }
    }
    
    // Finally, deallocate any chunks that are completely free and reset the indicies
    chunk = static_cast<HeapAllocator*>(heapimpl->m_heap_top);
    assert(chunk);
    HeapAllocator *in_use = nullptr;
    while (chunk) {
        bool used = false;
        for (int i=HEAP_RESERVED_SLOTS/8; i< HEAP_SLOTS/8; i++) {
            if (chunk->alloc_map[i] != 0) {
                used = true;
                break;
            }
        }
        HeapAllocator *next = static_cast<HeapAllocator*>(chunk->next_chunk());
        if (used) {
            chunk->set_next_chunk(in_use);
            if (in_use) in_use->set_next_chunk(chunk);
            in_use = chunk;

            // Reset all indicies
            for (int i=0; i<HEAP_SMALL_SPACE_LOG; i++)
                chunk->info.m_small_indicies[i] = HEAP_BLOCKS-1;
            chunk->info.m_large_index = 0;
            used_chunks ++;
        } else {
            free(chunk);
            freed_chunks ++;
        }
        chunk = next;
    }
    heapimpl->m_heap_top = in_use;
    
    // Finally finally, make any second pass phantom callbacks
    for (auto i=second_pass_callbacks.begin(); i != second_pass_callbacks.end(); ++i) {
        WeakCallbackInfo<void> info(reinterpret_cast<v8::Isolate*>(iso),
                                    (*i).param_,
                                    (*i).embedder_fields_,
                                    nullptr);
        (*i).callback_(info);
    }
    
    printf ("V82JSC Garbage Collector: Freed %d bytes; Deallocated %d / %d kB chunks; %d kB in use\n",
            freed, freed_chunks * 512, (freed_chunks+used_chunks) * 512, used_chunks * 512);
    
    return true;
}

void HeapAllocator::TearDown(IsolateImpl *isolate)
{
    internal::Heap *heap = reinterpret_cast<internal::Isolate*>(isolate)->heap();
    HeapImpl *heapimpl = reinterpret_cast<HeapImpl*>(heap);
    HeapAllocator *chunk = static_cast<HeapAllocator*>(heapimpl->m_heap_top);
    while (chunk) {
        auto done = chunk;
        chunk = static_cast<HeapAllocator*>(chunk->next_chunk());
        free(done);
    }
}

internal::MemoryChunk* internal::MemoryChunk::Initialize(internal::Heap* heap, internal::Address base, size_t size,
                                                         internal::Address area_start, internal::Address area_end,
                                                         internal::Executability executable, internal::Space* owner,
                                                         base::VirtualMemory* reservation)
{
    HeapImpl *heapimpl = reinterpret_cast<HeapImpl*>(heap);
    MemoryChunk *chunk = reinterpret_cast<MemoryChunk*>(base);
    memset(chunk, 0, sizeof(MemoryChunk));
    chunk->set_next_chunk(heapimpl->m_heap_top);
    heapimpl->m_heap_top = chunk;
    chunk->heap_ = heap;
    return chunk;
}
