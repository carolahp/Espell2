Class {
	#name : #SystemDictionaryAspect,
	#superclass : #PhAspect,
	#category : #Espell2Metamodel
}

{ #category : #initialization }
SystemDictionaryAspect >> createRemoteAdvice [
	^ PhAdvice new
		pointcut:
			(PhPointcut new
				receivers: 'CandleFromObjVLispLanguage';
				selectors: 'createRemoteSystemDictionary');
		advice: [ :context | 
			| code |
			code := '
		Smalltalk instVarAt: 1 put: SystemDictionary new.
		Smalltalk globals at: #Smalltalk put: Smalltalk.
		Smalltalk globals'.
			^ (context receiver newInstruction code: code) evaluate ];
		type: #around
]

{ #category : #initialization }
SystemDictionaryAspect >> initialize [
	super initialize.
	self
		add: self transformAdvice;
		add: self createRemoteAdvice;
		add: self loadGlobalVariablesAdvice
]

{ #category : #initialization }
SystemDictionaryAspect >> loadGlobalVariablesAdvice [
	^ PhAdvice new
		pointcut:
			(PhPointcut new
				receivers: 'CandleFromObjVLispLanguage';
				selectors: 'loadGlobalVariables');
		advice: [ :context | 
			context receiver globalVariables
				add:
					((context receiver class globalModel named: #Smalltalk parent: self)
						role: #Smalltalk;
						initializationCode: 'SmalltalkImage basicNew') ];
		type: #after
]

{ #category : #initialization }
SystemDictionaryAspect >> transformAdvice [
	^ PhAdvice new
		pointcut:
			(PhPointcut new
				receivers: 'CandleFromObjVLispLanguage';
				selectors: 'transform');
		advice: [ :context | 
			Transcript show: Character cr.
			Transcript show: 'Transform from aspect'.
			Transcript show: Character cr.];
		type: #after
]
