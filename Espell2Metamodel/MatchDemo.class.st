Class {
	#name : #MatchDemo,
	#superclass : #Object,
	#category : #Espell2Metamodel
}

{ #category : #'as yet unclassified' }
MatchDemo class >> buildModel [
	| pcClass pcLang membrane0 membrane1 aspClass aspLang match membrane2 |
	
	pcClass := PhPointcut new
		receivers: 'MatchClass';
		selectors: 'initialize';
		context: #('receiver').
		
	pcLang := PhPointcut new
		receivers: 'MatchLanguage';
		selectors: 'transform';
		context: #('receiver').
	
	membrane0 := PhMembrane new.
	membrane1 := PhMembrane new advise: membrane0.
	membrane2 := PhMembrane new advise: membrane1.
	aspClass := PhAspect new
		addClassModifier:
			(PhClassModifier new
				on:
					(PhPointcut receivers: 'MatchClass' selectors: #any asParser);
				addNewInstanceVar: #classPool;
				addNewInstanceMethod: 'classPool ^classPool';
				addNewInstanceMethod: 'classPool: anObject classPool := anObject';
				yourself);
		add:
			(PhAdvice new
				pointcut: pcClass;
				advice: [ :context | 
					context receiver classPool: Dictionary new ];
				type: #after); yourself.
	aspLang := PhAspect new
		add:
			(PhAdvice new
				pointcut: pcLang;
				advice: [ :context | 
					context receiver ensureClassNamed: 'Dog' ];
				type: #after); yourself.
	[
	 
	aspClass registerOn: membrane1.
	aspClass registerOn: membrane2.
	aspLang registerOn: membrane1.
	
	match := self newModel.
	membrane0 deployOn: match.
	
	self assert: PhAspectWeaver installedMembranes isEmpty.
	match build.
	self assert: (match classNamed: #Dog) isNotNil.
	self assert: (match classNamed: #Dog) classPool isDictionary.
	self assert: (match classNamed: #Class) classPool isDictionary.
	
	 ] ensure: [ 
		match destroy.
		aspClass unregisterFrom: membrane1.
		aspClass unregisterFrom: membrane2.
		aspLang unregisterFrom: membrane1.
		membrane0 uninstall.
	 ]
	
]

{ #category : #'as yet unclassified' }
MatchDemo class >> buildModel1 [
	| membrane0 membrane1 aspClass aspLang match membrane2 |
	
	aspClass := ClassVarAspect for: MatchClass.
	aspClass customFieldValues: {#Dog -> {#Kingdom -> #animal} asDictionary}.
	
	aspLang := LanguageAspect for: MatchLanguage.
	
	membrane0 := PhMembrane new.
	membrane1 := PhMembrane new advise: membrane0.
	membrane2 := PhMembrane new advise: membrane1.
	[
	 
	aspClass registerOn: membrane1.
	aspClass registerOn: membrane2.
	aspLang registerOn: membrane1.
	
	match := self newModel.
	membrane0 deployOn: match.
	
	self assert: PhAspectWeaver installedMembranes isEmpty.
	match build.
	self assert: (match classNamed: #Dog) isNotNil.
	self assert: (match classNamed: #Dog) classPool isDictionary.
	self assert: (match classNamed: #Class) classPool isDictionary.
	self assert: ((match classNamed: #Dog) classPool at: #Kingdom) = #animal.
	
	 ] ensure: [ 
		match destroy.
		aspClass unregisterFrom: membrane1.
		aspClass unregisterFrom: membrane2.
		aspLang unregisterFrom: membrane1.
		membrane0 undeployFrom: match.
		
	 ]
	
]

{ #category : #'as yet unclassified' }
MatchDemo class >> buildModel2 [
	| membrane0 membrane1 aspClass aspLang match membrane2 |
	aspClass := ClassVarAspect
		for: MatchClass
		customValues: {(#Dog -> {(#Kingdom -> #animal)} asDictionary)}.
	aspLang := LanguageAspect for: MatchLanguage.
	aspLang fieldAspects: {aspClass}.
	
	membrane0 := PhMembrane new.
	membrane1 := PhMembrane new advise: membrane0.
	membrane2 := PhMembrane new advise: membrane1.
	
	[ 
	aspClass registerOn: membrane1.
	aspClass registerOn: membrane2.
	aspLang registerOn: membrane1.
	match := self newModel.
	membrane0 deployOn: match.
	self assert: PhAspectWeaver installedMembranes isEmpty.
	match build.
	self assert: (match classNamed: #Dog) isNotNil.
	self assert: (match classNamed: #Dog) classPool isDictionary.
	self assert: (match classNamed: #Class) classPool isDictionary.
	self assert: ((match classNamed: #Dog) classPool at: #Kingdom) = #animal.
	self assert: ((match classNamed: #Class) methodDict at: #classPool) isNotNil 
	]	
	ensure: [ match destroy.
			aspClass unregisterFrom: membrane1.
			aspClass unregisterFrom: membrane2.
			aspLang unregisterFrom: membrane1.
			membrane0 undeployFrom: match ]
]

{ #category : #'as yet unclassified' }
MatchDemo class >> buildModelAndGenerate [
	| membrane0 membrane1 aspClass aspLang match membrane2 |
	
	aspClass := ClassVarAspect for: MatchClass.	
	aspClass customFieldValues: {#Dog -> {#Kingdom -> #animal} asDictionary}.
	aspLang := LanguageAspect for: MatchLanguage.
	
	membrane0 := PhMembrane new.
	membrane1 := PhMembrane new advise: membrane0.
	membrane2 := PhMembrane new advise: membrane1.
	[
	 
	aspClass registerOn: membrane1.
	aspClass registerOn: membrane2.
	aspLang registerOn: membrane1.
	
	match := self newModel.
	membrane0 deployOn: match.
	
	self assert: PhAspectWeaver installedMembranes isEmpty.
	match build.
	self assert: (match classNamed: #Dog) isNotNil.
	self assert: (match classNamed: #Dog) classPool isDictionary.
	self assert: (match classNamed: #Dog) isNotNil.
	self assert: (match classNamed: #Class) classPool isDictionary.
	
	match generate.
	self assert: (match classNamed: #Dog) remote isNotNil.
	self assert: (match classNamed: #Dog) remote classPool isEP2Remote.
	self assert: ((match classNamed: #Dog) remote classPool at: #Kingdom) asLocalString = 'animal'.
	
	 ] ensure: [ 
		aspClass unregisterFrom: membrane1.
		aspClass unregisterFrom: membrane2.
		aspLang unregisterFrom: membrane1.
		membrane0 undeployFrom: match.
		match destroy.
	 ]
	
]

{ #category : #'as yet unclassified' }
MatchDemo class >> buildModelAndGenerate2 [
	| membrane0 membrane1 aspClass aspLang match membrane2 |
	aspClass := ClassVarAspect
		for: MatchClass
		customValues: {(#Dog -> {(#Kingdom -> #animal)} asDictionary)}.
	aspLang := LanguageAspect for: MatchLanguage.
	aspLang fieldAspects: {aspClass}.
	
	membrane0 := PhMembrane new.
	membrane1 := PhMembrane new advise: membrane0.
	membrane2 := PhMembrane new advise: membrane1.
	
	[ 
	aspClass registerOn: membrane1.
	aspClass registerOn: membrane2.
	aspLang registerOn: membrane1.
	match := self newModel.
	membrane0 deployOn: match.
	self assert: PhAspectWeaver installedMembranes isEmpty.
	match build.
	self assert: (match classNamed: #Dog) isNotNil.
	self assert: (match classNamed: #Dog) classPool isDictionary.
	self assert: (match classNamed: #Class) classPool isDictionary.
	self assert: ((match classNamed: #Dog) classPool at: #Kingdom) = #animal.
	self assert: ((match classNamed: #Class) methodDict at: #classPool) isNotNil.
	match generate.
	self assert: (match classNamed: #Dog) remote isNotNil.
	self assert: (match classNamed: #Dog) remote classPool isEP2Remote.
	self assert: ((match classNamed: #Dog) remote classPool at: #Kingdom) asLocalString = 'animal'.
	
	]
	ensure: [ match destroy.
			aspClass unregisterFrom: membrane1.
			aspClass unregisterFrom: membrane2.
			aspLang unregisterFrom: membrane1.
			membrane0 undeployFrom: match ]
]

{ #category : #'as yet unclassified' }
MatchDemo class >> buildModelAndGenerate3 [
	| aspClass aspShPools aspLang membrane0 membrane1 membrane2 match |
	aspClass := ClassVarAspect
		for: MatchClass
		customValues:
			{(#Dog
				->
					{(#Kingdom -> #animal).
					(#Greet -> #guau)} asDictionary)}.
	aspShPools := SharedPoolsAspect
		for: MatchClass
		customValues:
			{(#Dog
				->
					{(#Kingdom -> #sharedAnimal).
					(#PoolGreet -> #poolgreet)} asDictionary)}.
	aspLang := LanguageAspect for: MatchLanguage.
	aspLang
		fieldAspects:
			{aspShPools.
			aspClass}.
	membrane0 := PhMembrane new.
	membrane1 := PhMembrane new advise: membrane0.
	membrane2 := PhMembrane new advise: membrane1.
	[ aspClass registerOn: membrane1.
	aspClass registerOn: membrane2.
	aspShPools registerOn: membrane1.
	aspShPools registerOn: membrane2.
	aspLang registerOn: membrane1.
	match := MatchDemo newModel.
	membrane0 deployOn: match.
	self assert: PhAspectWeaver installedMembranes isEmpty.
	match build.
	self assert: (match classNamed: #Dog) isNotNil.
	self assert: (match classNamed: #Dog) classPool isDictionary.
	self assert: (match classNamed: #Class) classPool isDictionary.
	self
		assert: ((match classNamed: #Dog) classPool at: #Kingdom) = #animal.
	self
		assert: ((match classNamed: #Class) methodDict at: #classPool) isNotNil.
	self assert: (match classNamed: #Dog) mySharedPools isDictionary.
	self
		assert: ((match classNamed: #Dog) mySharedPools at: #Kingdom) = #sharedAnimal.
	self
		assert: ((match classNamed: #Class) methodDict at: #mySharedPools) isNotNil.
	match generate.
	self assert: (match classNamed: #Dog) remote isNotNil.
	self
		assert:
			((match classNamed: #Dog) remote classPool bindingOf: #Kingdom) value
				asLocalString = 'animal'.
	self assert: (match classNamed: #Dog) remote classPool isEP2Remote.
	self
		assert:
			((match classNamed: #Dog) remote classPool at: #Kingdom) asLocalString
				= 'animal'.
	self
		assert:
			((match classNamed: #Dog) remote mySharedPools at: #Kingdom)
				asLocalString = 'sharedAnimal'.
	self
		assert: (match evaluateCode: 'Dog new kingdom') asLocalString = #sharedAnimal.
	self
		assert: ((match classNamed: #Dog) innerBindingOf: #Kingdom) = #sharedAnimal.
	self
		assert: ((match classNamed: #Dog) innerBindingOf: #Greet) = #guau.
	self
		assert: ((match classNamed: #Dog) innerBindingOf: #PoolGreet) = #poolgreet ]
		
		ensure: [ aspClass unregisterFrom: membrane1.
			aspClass unregisterFrom: membrane2.
			aspShPools unregisterFrom: membrane1.
			aspShPools unregisterFrom: membrane2.
			aspLang unregisterFrom: membrane1.
			membrane0 undeployFrom: match.
			PhAspectWeaver panicCleanAndResetAll.
			match destroy ]
]

{ #category : #'as yet unclassified' }
MatchDemo class >> newModel [
	^ MatchLanguage
		newFromModel: '/Users/carolina.hernandez/Documents/restaurado/bootstrap/language-definitions/ObjVLispMin' asFileReference
		withName: 'Match'
		withEntryPoint: 'System log: ''match!''.
		System quit'.
]
