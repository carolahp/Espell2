Class {
	#name : #EP2InternalSymbolTable,
	#superclass : #EP2SymbolTable,
	#instVars : [
		'cache'
	],
	#category : #'Espell2-Image'
}

{ #category : #public }
EP2InternalSymbolTable >> at: aLocalSymbol [
self halt:'internal symbol table is used!'.
	^ cache at: aLocalSymbol ifAbsentPut: [ super at: aLocalSymbol ]
]

{ #category : #public }
EP2InternalSymbolTable >> at: aLocalSymbol ifAbsent: aBlock [

	^ cache at: aLocalSymbol ifAbsent: [ self like: aLocalSymbol ifAbsent: aBlock ].
]

{ #category : #public }
EP2InternalSymbolTable >> at: aLocalSymbol ifAbsentPut: aBlock [

	^ cache at: aLocalSymbol ifAbsent: [
		super at: aLocalSymbol ifAbsentPut: aBlock ]
]

{ #category : #accessing }
EP2InternalSymbolTable >> at: aLocalSymbol put: aMirrorOnTheSymbol [

	^ cache at: aLocalSymbol put: aMirrorOnTheSymbol
]

{ #category : #initialization }
EP2InternalSymbolTable >> buildCache [

	self symbolsDo: [ :each | cache at: each asLocalString asSymbol put: each ]
]

{ #category : #accessing }
EP2InternalSymbolTable >> cachedSymbols [
	
	^ cache keys
]

{ #category : #public }
EP2InternalSymbolTable >> includesCachedKey: aLocalSymbol [

	^ cache includesKey: aLocalSymbol
]

{ #category : #public }
EP2InternalSymbolTable >> includesKey: aLocalSymbol [

	^ (cache includesKey: aLocalSymbol) or: [ super includesKey: aLocalSymbol ]
]

{ #category : #initialization }
EP2InternalSymbolTable >> initialize [

	super initialize.
	cache := Dictionary new.
]

{ #category : #public }
EP2InternalSymbolTable >> installSymbol: aRemoteSymbol [

	cache at: aRemoteSymbol asLocalLiteral put: aRemoteSymbol.
	^ objectSpace interpreter evaluateCode: 'Symbol intern: aSymbol' withTemps: { 'aSymbol' -> aRemoteSymbol }
]

{ #category : #'private-iterating' }
EP2InternalSymbolTable >> iterateSymbolArray: anArray with: aBlock [

	| array |
	array := anArray.
	1 to: array size do: [ :i | | element |
		element := array at: i.
		aBlock value: element.
	]
]

{ #category : #'private-iterating' }
EP2InternalSymbolTable >> iterateSymbolWeakSet: aWeakSet with: aBlock [
	| array flag |
	array := aWeakSet instanceVariableAtIndex: 2.
	flag := aWeakSet instanceVariableAtIndex: 3.
	1 to: array size do: [ :i | 
		| element |
		element := array at: i.
		(nil ~~ element target and: [ element isNilObject not and: [ element ~= flag ] ])
			ifTrue: [ aBlock value: element ] ]
]

{ #category : #public }
EP2InternalSymbolTable >> like: aString ifAbsent: aBlock [

	| symbolClass symbolClassPools arrayClass |
	arrayClass := objectSpace backend arrayClass.
	symbolClass := objectSpace backend symbolTableClass asClassMirror.
	symbolClassPools := symbolClass classPool instanceVariableAtIndex: (objectSpace backend instanceVariableMapping dictionaryArrayIndex).
	1 to: symbolClassPools size do: [ :i | | associationOrNil |
		associationOrNil := symbolClassPools at: i.
		associationOrNil isNilObject ifFalse: [ | symbolSet |
			symbolSet := associationOrNil instanceVariableAtIndex: 2.
			symbolSet isNilObject ifFalse: [
				symbolSet basicClass = arrayClass
					ifTrue: [ 
						self
							iterateSymbolArray: symbolSet
							with:  [ :remoteSymbol | remoteSymbol asLocalString = aString ifTrue: [ ^ remoteSymbol ] ]. ]
					ifFalse: [ 
						| found |
						found := (EPRemoteWeakSet on: symbolSet) like: aString ifAbsent: [ nil ].
						found ifNotNil: [ ^ found ]]
					] ] ].
		^ aBlock value
]

{ #category : #public }
EP2InternalSymbolTable >> symbolsDo: aBlock [

	| symbolClass symbolClassPools arrayClass |
	arrayClass := objectSpace backend arrayClass.
	symbolClass := objectSpace backend symbolTableClass asClassMirror.
	symbolClassPools := symbolClass classPool instanceVariableAtIndex: (self instanceVariableMapping dictionaryArrayIndex).
	1 to: symbolClassPools size do: [ :i | | associationOrNil |
		associationOrNil := symbolClassPools at: i.
		associationOrNil isNilObject ifFalse: [ | symbolSet |
			symbolSet := associationOrNil instanceVariableAtIndex: 2.
			symbolSet isNilObject ifFalse: [
				symbolSet basicClass = arrayClass
					ifTrue: [ self iterateSymbolArray: symbolSet with: aBlock ]
					ifFalse: [ self iterateSymbolWeakSet: symbolSet with: aBlock] ] ].
	].
]

{ #category : #accessing }
EP2InternalSymbolTable >> toInternalSymbolTable [
	
	^ self
]
