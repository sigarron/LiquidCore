//
//  LiquidCoreiOSTests.m
//  LiquidCoreiOSTests
//
//  Created by Eric Lange on 1/28/18.
//  Copyright © 2018 LiquidPlayer. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "helloworld.h"

extern int cctest_main(int argc, char* argv[]);

@interface LiquidCoreiOSTests : XCTestCase

@end

@implementation LiquidCoreiOSTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testHelloWorld {
    char *argv[] = { "foo" };
    helloworld(1, argv);
}

/*
- (void)testCc {
    char *argv[] = { "cctest", "--list" };
    cctest_main(2, argv);
}
*/

#undef V
#define V(tst) \
- (void)testCcPassing##tst { \
char *argv[] = { "cctest", "test-api/" #tst }; \
cctest_main(2, argv); \
}
/******* PASSING TESTS *******/
V(InitializeAndDisposeOnce)
V(InitializeAndDisposeMultiple)
V(SmiZero)
V(Handles)
V(IsolateOfContext)
V(HulIgennem)
V(Access)
V(AccessElement)
V(Script)
V(ScriptUsingStringResource)
V(ScriptUsingOneByteStringResource)
V(ScriptMakingExternalString)
V(ScriptMakingExternalOneByteString)
V(MakingExternalStringConditions)
V(MakingExternalOneByteStringConditions)
V(MakingExternalUnalignedOneByteString)
V(UsingExternalString)
V(UsingExternalOneByteString)
V(NewExternalForVeryLongString)
V(ScavengeExternalString)
V(ScavengeExternalOneByteString)
V(ExternalStringWithDisposeHandling)
V(StringConcat)
V(GlobalProperties)
V(ExternalWrap)
V(TinyInteger)
V(BigSmiInteger)
V(BigInteger)
V(TinyUnsignedInteger)
V(BigUnsignedSmiInteger)
V(BigUnsignedInteger)
V(OutOfSignedRangeUnsignedInteger)
V(IsNativeError)
V(IsGeneratorFunctionOrObject)
V(IsAsyncFunction)
V(ArgumentsObject)
V(IsMapOrSet)
V(StringObject)
V(StringObjectDelete)
V(NumberObject)
V(BooleanObject)
V(PrimitiveAndWrappedBooleans)
V(Number)
V(ToNumber)
V(Date)
V(Boolean)
V(IntegerValue)
V(UndefinedIsNotEnumerable)
V(DeepCrossLanguageRecursion)
V(GetSetProperty)
V(TypeOf)
V(ScriptException)
V(LocalHandle)
V(ReceiverSignature) // Start ObjectTemplate/FunctionTemplate tests
V(FunctionTemplateWithProfiler)
V(FunctionTemplate)
V(SimpleCallbackWithProfiler)
V(SimpleCallback)
V(FastReturnValuesWithProfiler)
V(FastReturnValues)
V(FunctionTemplateSetLength)
V(FindInstanceInPrototypeChain)
V(GlobalPrototype)
V(ObjectTemplate)
V(FunctionPrototype)
V(ConstructCall)
V(TestObjectTemplateInheritedWithAccessorsInPrototype1)
V(TestObjectTemplateInheritedWithAccessorsInPrototype2)
V(TestObjectTemplateInheritedWithAccessorsInPrototype3)
V(TestObjectTemplateInheritedWithPrototype1)
V(TestObjectTemplateInheritedWithPrototype2)
V(TestObjectTemplateClassInheritance)
V(TestObjectTemplateReflectConstruct)
V(DescriptorInheritance)
V(DescriptorInheritance2)
V(CallbackExceptionRegression)
V(InternalFields)
V(GlobalObjectInternalFields)
V(GlobalObjectHasRealIndexedProperty)
V(InternalFieldsAlignedPointers)
V(SetAlignedPointerInInternalFields)
V(SymbolIdentityHash)
V(StringIdentityHash)
V(SymbolProperties)
V(SymbolTemplateProperties)
V(GlobalSymbols)
V(GlobalSymbolsNoContext)
V(WellKnownSymbols)
V(EmbedderDataAlignedPointers)
V(EmbedderData)

#undef V
#define V(tst) \
- (void)testCc##tst { \
char *argv[] = { "cctest", "test-api/" #tst }; \
cctest_main(2, argv); \
}

V(AccessorIsPreservedOnAttributeChange)
V(IdentityHash)
V(GlobalProxyIdentityHash)
V(PrivatePropertiesOnProxies)
V(PrivateProperties)
V(GlobalPrivates)
V(ArrayBuffer_ApiInternalToExternal)
V(ArrayBuffer_JSInternalToExternal)
V(ArrayBuffer_External)
V(ArrayBuffer_DisableNeuter)
V(ArrayBuffer_NeuteringApi)
V(ArrayBuffer_NeuteringScript)
V(SharedArrayBuffer_ApiInternalToExternal)
V(SharedArrayBuffer_JSInternalToExternal)
V(SharedArrayBuffer_External)
V(HiddenProperties)
V(Regress97784)
V(External)
V(GlobalHandle)
V(ResettingGlobalHandle)
V(ResettingGlobalHandleToEmpty)
V(Global)
V(TwoPassPhantomCallbacks)
V(TwoPassPhantomCallbacksNestedGc)
V(GlobalValueMap)
V(PersistentValueVector)
V(GlobalHandleUpcast)
V(HandleEquality)
V(TryCatchCustomException)
V(MessageHandler0)
V(MessageHandler1)
V(MessageHandler2)
V(MessageHandler3)
V(MessageHandler4)
V(MessageHandler5)
V(NativeWeakMap)
V(PropertyAttributes)
V(Array)
V(Vector)
V(FunctionCall)
V(ConversionNumber)
V(isNumberType)
V(ConversionException)
V(APICatch)
V(APIThrowTryCatch)
V(TryCatchInTryFinally)
V(CustomErrorToString)
V(CustomErrorMessage)
V(CustomErrorRethrowsOnToString)
V(APIThrowMessage)
V(APIThrowMessageAndVerboseTryCatch)
V(APIStackOverflowAndVerboseTryCatch)
V(ExternalScriptException)
V(EvalInTryFinally)
V(ExceptionOrder)
V(ThrowValues)
V(CatchZero)
V(CatchExceptionFromWith)
V(TryCatchAndFinallyHidingException)
V(TryCatchAndFinally)
V(TryCatchNested)
V(TryCatchMixedNesting)
V(TryCatchNative)
V(TryCatchNativeReset)
V(Equality)
V(InstanceOf)
V(MultiRun)
V(SimplePropertyRead)
V(DefinePropertyOnAPIAccessor)
V(DefinePropertyOnDefineGetterSetter)
V(DefineAPIAccessorOnObject)
V(DontDeleteAPIAccessorsCannotBeOverriden)
V(ElementAPIAccessor)
V(SimplePropertyWrite)
V(SetterOnly)
V(NoAccessors)
V(MultiContexts)
V(FunctionPrototypeAcrossContexts)
V(Regress892105)
V(UndetectableObject)
V(VoidLiteral)
V(ExtensibleOnUndetectable)
V(PersistentHandles)
V(GlobalObjectTemplate)
V(SimpleExtensions)
V(StackTraceInExtension)
V(NullExtensions)
V(ExtensionMissingSourceLength)
V(ExtensionWithSourceLength)
V(UseEvalFromExtension)
V(UseWithFromExtension)
V(AutoExtensions)
V(SyntaxErrorExtensions)
V(ExceptionExtensions)
V(NativeCallInExtensions)
V(NativeFunctionDeclaration)
V(NativeFunctionDeclarationError)
V(NativeFunctionDeclarationErrorEscape)
V(ExtensionDependency)
V(FunctionLookup)
V(NativeFunctionConstructCall)
V(ErrorReporting)
V(ErrorWithMissingScriptInfo)
V(IndependentWeakHandle)
V(InternalFieldCallback)
V(ResetWeakHandle)
V(GCFromWeakCallbacks)
V(Arguments)
V(GetterHolders)
V(PreInterceptorHolders)
V(ObjectInstantiation)
V(StringWrite)
V(Utf16)
V(Utf16Symbol)
V(Utf16MissingTrailing)
V(Utf16Trailing3Byte)
V(ToArrayIndex)
V(ErrorConstruction)
V(ExceptionCreateMessage)
V(ExceptionCreateMessageLength)
V(DeleteAccessor)
V(ApiUncaughtException)
V(ExceptionInNativeScript)
V(CompilationErrorUsingTryCatchHandler)
V(TryCatchFinallyUsingTryCatchHandler)
V(TryCatchFinallyStoresMessageUsingTryCatchHandler)
V(SecurityHandler)
V(SecurityChecks)
V(SecurityChecksForPrototypeChain)
V(SecurityTestGCAllowed)
V(CrossDomainDelete)
V(CrossDomainPropertyIsEnumerable)
V(CrossDomainFor)
V(CrossDomainForInOnPrototype)
V(ContextDetachGlobal)
V(DetachGlobal)
V(DetachedAccesses)
V(AccessControl)
V(AccessControlES5)
V(AccessControlGetOwnPropertyNames)
V(Regress470113)
V(CrossDomainAccessors)
V(AccessControlIC)
V(Version)
V(InstanceProperties)
V(GlobalObjectInstanceProperties)
V(ObjectGetOwnPropertyNames)
V(CallKnownGlobalReceiver)
V(ShadowObject)
V(HiddenPrototype)
V(HiddenPrototypeSet)
V(HiddenPrototypeIdentityHash)
V(SetPrototype)
V(Regress91517)
V(Regress269562)
V(FunctionReadOnlyPrototype)
V(SetPrototypeThrows)
V(FunctionRemovePrototype)
V(GetterSetterExceptions)
V(Constructor)
V(ConstructorForObject)
V(FunctionDescriptorException)
V(EvalAliasedDynamic)
V(CrossEval)
V(EvalInDetachedGlobal)
V(CrossLazyLoad)
V(CallAsFunction)
V(CallableObject)
V(Regress567998)
V(HandleIteration)
V(CallICFastApi_DirectCall_GCMoveStub)
V(CallICFastApi_DirectCall_Throw)
V(LoadICFastApi_DirectCall_GCMoveStubWithProfiler)
V(LoadICFastApi_DirectCall_GCMoveStub)
V(LoadICFastApi_DirectCall_Throw)
V(InterceptorCallICFastApi_TrivialSignatureWithProfiler)
V(InterceptorCallICFastApi_TrivialSignature)
V(InterceptorCallICFastApi_SimpleSignatureWithProfiler)
V(InterceptorCallICFastApi_SimpleSignature)
V(InterceptorCallICFastApi_SimpleSignature_Miss1WithProfiler)
V(InterceptorCallICFastApi_SimpleSignature_Miss1)
V(InterceptorCallICFastApi_SimpleSignature_Miss2WithProfiler)
V(InterceptorCallICFastApi_SimpleSignature_Miss2)
V(InterceptorCallICFastApi_SimpleSignature_Miss3WithProfiler)
V(InterceptorCallICFastApi_SimpleSignature_Miss3)
V(InterceptorCallICFastApi_SimpleSignature_TypeErrorWithProfiler)
V(InterceptorCallICFastApi_SimpleSignature_TypeError)
V(CallICFastApi_TrivialSignatureWithProfiler)
V(CallICFastApi_TrivialSignature)
V(CallICFastApi_SimpleSignatureWithProfiler)
V(CallICFastApi_SimpleSignature)
V(CallICFastApi_SimpleSignature_Miss1WithProfiler)
V(CallICFastApi_SimpleSignature_Miss1)
V(CallICFastApi_SimpleSignature_Miss2WithProfiler)
V(CallICFastApi_SimpleSignature_Miss2)
V(CallICFastApi_SimpleSignature_TypeErrorWithProfiler)
V(CallICFastApi_SimpleSignature_TypeError)
V(VariousGetPropertiesAndThrowingCallbacks)
V(ExceptionsDoNotPropagatePastTryCatch)
V(Overriding)
V(AccessorShouldThrowOnError)
V(InterceptorShouldThrowOnError)
V(IsConstructCall)
V(NewTargetHandler)
V(ObjectProtoToString)
V(ObjectProtoToStringES6)
V(ObjectGetConstructorName)
V(SubclassGetConstructorName)
V(Threading1)
V(Threading2)
V(Threading3)
V(Threading4)
V(Threading5)
V(Threading6)
V(Threading7)
V(Threading8)
V(NestedLockers)
V(NestedLockersNoTryCatch)
V(RecursiveLocking)
V(LockUnlockLock)
V(DontLeakGlobalObjects)
V(CopyablePersistent)
V(WeakCallbackApi)
V(NewPersistentHandleFromWeakCallback)
V(DoNotUseDeletedNodesInSecondLevelGc)
V(NoGlobalHandlesOrphaningDueToWeakCallback)
V(CheckForCrossContextObjectLiterals)
V(NestedHandleScopeAndContexts)
V(SetFunctionEntryHook)
V(SetJitCodeEventHandler)
V(ExternalAllocatedMemory)
V(Regress51719)
V(Regress54)
V(CatchStackOverflow)
V(TryCatchSourceInfo)
V(TryCatchSourceInfoForEOSError)
V(CompilationCache)
V(CallbackFunctionName)
V(DateAccess)
V(PropertyEnumeration)
V(PropertyEnumeration2)
V(PropertyNames)
V(AccessChecksReenabledCorrectly)
V(PreCompileSerialization)
V(DictionaryICLoadedFunction)
V(CrossContextNew)
V(ObjectClone)
V(MorphCompositeStringTest)
V(CompileExternalTwoByteSource)
V(RegExpInterruption)
V(ReadOnlyPropertyInGlobalProto)
V(CreateDataProperty)
V(DefineOwnProperty)
V(DefineProperty)
V(GetCurrentContextWhenNotInContext)
V(InitGlobalVarInProtoChain)
V(ReplaceConstantFunction)
V(FixedUint8Array)
V(FixedUint8ClampedArray)
V(FixedInt8Array)
V(FixedUint16Array)
V(FixedInt16Array)
V(FixedUint32Array)
V(FixedInt32Array)
V(FixedFloat32Array)
V(FixedFloat64Array)
V(Uint8Array)
V(Int8Array)
V(Uint16Array)
V(Int16Array)
V(Uint32Array)
V(Int32Array)
V(Float32Array)
V(Float64Array)
V(Uint8ClampedArray)
V(DataView)
V(SkipArrayBufferBackingStoreDuringGC)
V(SkipArrayBufferDuringScavenge)
V(SharedUint8Array)
V(SharedInt8Array)
V(SharedUint16Array)
V(SharedInt16Array)
V(SharedUint32Array)
V(SharedInt32Array)
V(SharedFloat32Array)
V(SharedFloat64Array)
V(SharedUint8ClampedArray)
V(SharedDataView)
V(IsUint8Array)
V(IsInt8Array)
V(IsUint16Array)
V(IsInt16Array)
V(IsUint32Array)
V(IsInt32Array)
V(IsFloat32Array)
V(IsFloat64Array)
V(IsUint8ClampedArray)
V(IsDataView)
V(ScriptContextDependence)
V(StackTrace)
V(CaptureStackTrace)
V(CaptureStackTraceForUncaughtException)
V(CaptureStackTraceForUncaughtExceptionAndSetters)
V(AsmJsWarning)
V(ErrorLevelWarning)
V(GetStackTraceContainsFunctionsWithFunctionName)
V(RethrowStackTrace)
V(RethrowPrimitiveStackTrace)
V(RethrowExistingStackTrace)
V(RethrowBogusErrorStackTrace)
V(PromiseRejectCallback)
V(SourceURLInStackTrace)
V(ScriptIdInStackTrace)
V(InlineScriptWithSourceURLInStackTrace)
V(PromiseHook)
V(DynamicWithSourceURLInStackTrace)
V(DynamicWithSourceURLInStackTraceString)
V(EvalWithSourceURLInMessageScriptResourceNameOrSourceURL)
V(RecursionWithSourceURLInMessageScriptResourceNameOrSourceURL)
V(TestIdleNotification)
V(Regress2333)
V(SetStackLimit)
V(SetStackLimitInThread)
V(GetHeapStatistics)
V(ExternalizeOldSpaceTwoByteCons)
V(ExternalizeOldSpaceOneByteCons)
V(VisitExternalStrings)
V(ExternalStringCollectedAtTearDown)
V(ExternalInternalizedStringCollectedAtTearDown)
V(ExternalInternalizedStringCollectedAtGC)
V(QuietSignalingNaNs)
V(SpaghettiStackReThrow)
V(Regress528)
V(ScriptOrigin)
V(FunctionGetInferredName)
V(FunctionGetDebugName)
V(FunctionGetDisplayName)
V(ScriptLineNumber)
V(ScriptColumnNumber)
V(FunctionGetScriptId)
V(FunctionGetBoundFunction)
V(SetterOnConstructorPrototype)
V(InterceptorOnConstructorPrototype)
V(Regress618)
V(GCCallbacksOld)
V(GCCallbacksWithData)
V(GCCallbacks)
V(TwoByteStringInOneByteCons)
V(ContainsOnlyOneByte)
V(GCInFailedAccessCheckCallback)
V(IsolateNewDispose)
V(DisposeIsolateWhenInUse)
V(VerifyArrayPrototypeGuarantees)
V(RunTwoIsolatesOnSingleThread)
V(MultipleIsolatesOnIndividualThreads)
V(IsolateDifferentContexts)
V(InitializeDefaultIsolateOnSecondaryThread1)
V(InitializeDefaultIsolateOnSecondaryThread2)
V(InitializeDefaultIsolateOnSecondaryThread3)
V(InitializeDefaultIsolateOnSecondaryThread4)
V(InitializeDefaultIsolateOnSecondaryThread5)
V(StringCheckMultipleContexts)
V(NumberCheckMultipleContexts)
V(BooleanCheckMultipleContexts)
V(DontDeleteCellLoadIC)
V(PersistentHandleVisitor)
V(WrapperClassId)
V(PersistentHandleInNewSpaceVisitor)
V(RegExp)
V(Equals)
V(NamedEnumeratorAndForIn)
V(DefinePropertyPostDetach)
V(CreationContext)
V(CreationContextOfJsFunction)
V(CreationContextOfJsBoundFunction)
V(HasOwnProperty)
V(IndexedInterceptorWithStringProto)
V(AllowCodeGenFromStrings)
V(SetErrorMessageForCodeGenFromStrings)
V(CaptureSourceForCodeGenFromStrings)
V(CallAPIFunctionOnNonObject)
V(ReadOnlyIndexedProperties)
V(Regress1516)
V(Regress93759)
V(ForeignFunctionReceiver)
V(CallCompletedCallback)
V(CallCompletedCallbackOneException)
V(CallCompletedCallbackTwoExceptions)
V(EnqueueMicrotask)
V(RunMicrotasksIgnoresThrownExceptions)
V(SetAutorunMicrotasks)
V(RunMicrotasksWithoutEnteringContext)
V(ScopedMicrotasks)
V(CheckCOWArraysCreatedRuntimeCounter)
V(StaticGetters)
V(IsolateEmbedderData)
V(StringEmpty)
V(InstanceCheckOnInstanceAccessor)
V(InstanceCheckOnInstanceAccessorWithInterceptor)
V(InstanceCheckOnPrototypeAccessor)
V(TryFinallyMessage)
V(Regress137002a)
V(Regress137002b)
V(Regress142088)
V(Regress137496)
V(Regress157124)
V(Regress2535)
V(Regress2746)
V(Regress260106)
V(JSONParseObject)
V(JSONParseNumber)
V(JSONParseArray)
V(JSONStringifyObject)
V(JSONStringifyObjectWithGap)
V(SemaphoreInterruption)
V(JSONStringifyAccessCheck)
V(AccessCheckThrows)
V(AccessCheckInIC)
V(RequestInterruptTestWithFunctionCall)
V(RequestInterruptTestWithMethodCall)
V(RequestInterruptTestWithAccessor)
V(RequestInterruptTestWithNativeAccessor)
V(RequestInterruptTestWithMethodCallAndInterceptor)
V(RequestInterruptTestWithMathAbs)
V(RequestMultipleInterrupts)
V(RequestInterruptSmallScripts)
V(FunctionNew)
V(EscapeableHandleScope)
V(Regress239669)
V(FunctionCallOptimization)
V(FunctionCallOptimizationMultipleArgs)
V(ApiCallbackCanReturnSymbols)
V(EmptyApiCallback)
V(SimpleSignatureCheck)
V(ChainSignatureCheck)
V(PrototypeSignatureCheck)
V(EventLogging)
V(PropertyDescriptor)
V(Promises)
V(PromiseThen)
V(PromiseStateAndValue)
V(DisallowJavascriptExecutionScope)
V(AllowJavascriptExecutionScope)
V(ThrowOnJavascriptExecution)
V(Regress354123)
V(CaptureStackTraceForStackOverflow)
V(ScriptNameAndLineNumber)
V(ScriptPositionInfo)
V(ScriptSourceURLAndSourceMappingURL)
V(GetOwnPropertyDescriptor)
V(Regress411877)
V(GetHiddenPropertyTableAfterAccessCheck)
V(Regress411793)
V(StreamingSimpleScript)
V(StreamingScriptConstantArray)
V(StreamingScriptEvalShadowing)
V(StreamingBiggerScript)
V(StreamingScriptWithParseError)
V(StreamingUtf8Script)
V(StreamingUtf8ScriptWithSplitCharactersSanityCheck)
V(StreamingUtf8ScriptWithSplitCharacters)
V(StreamingUtf8ScriptWithSplitCharactersValidEdgeCases)
V(StreamingUtf8ScriptWithSplitCharactersInvalidEdgeCases)
V(StreamingProducesParserCache)
V(StreamingWithDebuggingEnabledLate)
V(StreamingScriptWithInvalidUtf8)
V(StreamingUtf8ScriptWithMultipleMultibyteCharactersSomeSplit)
V(StreamingUtf8ScriptWithMultipleMultibyteCharactersSomeSplit2)
V(StreamingWithHarmonyScopes)
V(CodeCache)
V(InvalidParserCacheData)
V(InvalidCodeCacheData)
V(ParserCacheRejectedGracefully)
V(StringConcatOverflow)
V(TurboAsmDisablesNeuter)
V(GetPrototypeAccessControl)
V(GetPrototypeHidden)
V(ClassPrototypeCreationContext)
V(SimpleStreamingScriptWithSourceURL)
V(StreamingScriptWithSplitSourceURL)
V(StreamingScriptWithSourceMappingURLInTheMiddle)
V(NewStringRangeError)
V(SealHandleScope)
V(SealHandleScopeNested)
V(ExtrasFunctionSource)
V(ExtrasBindingObject)
V(ExperimentalExtras)
V(ExtrasUtilsObject)
V(Map)
V(Set)
V(SetDeleteThenAsArray)
V(MapDeleteThenAsArray)
V(CompatibleReceiverCheckOnCachedICHandler)
V(ReceiverConversionForAccessors)
V(FutexInterruption)
V(AbortOnUncaughtExceptionNoAbort)
V(AccessCheckedIsConcatSpreadable)
V(AccessCheckedToStringTag)
V(TemplateIteratorPrototypeIntrinsics)
V(TemplateErrorPrototypeIntrinsics)
V(ObjectTemplateArrayProtoIntrinsics)
V(ObjectTemplatePerContextIntrinsics)
V(Proxy)
V(MemoryPressure)
V(SetIntegrityLevel)
V(PrivateForApiIsNumber)
V(ImmutableProto)
V(CrossActivationEval)
V(EvalInAccessCheckedContext)
V(ImmutableProtoWithParent)
V(InternalFieldsOnGlobalProxy)
V(ImmutableProtoGlobal)
V(MutableProtoGlobal)
V(InternalFieldsOnTypedArray)
V(InternalFieldsOnDataView)
V(SetPrototypeTemplate)
V(GlobalAccessorInfo)
V(IncreaseHeapLimitForDebugging)
V(DeterministicRandomNumberGeneration)
V(AllowAtomicsWait)
V(CorrectEnteredContext)
V(DynamicImport)
@end
