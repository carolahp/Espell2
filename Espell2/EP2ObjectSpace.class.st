Class {
	#name : #EP2ObjectSpace,
	#superclass : #Object,
	#instVars : [
		'backend',
		'characterTable',
		'symbolTable',
		'interpreter',
		'debuggerInterpreter',
		'specialObjectsArray'
	],
	#category : #Espell2
}

{ #category : #accessing }
EP2ObjectSpace >> backend [
	^ backend
]

{ #category : #accessing }
EP2ObjectSpace >> backend: anEP2Backend [ 
	backend := anEP2Backend 
]

{ #category : #accessing }
EP2ObjectSpace >> characterTable: anEPExternalCharacterTable [ 
	characterTable := anEPExternalCharacterTable 
	
]

{ #category : #accessing }
EP2ObjectSpace >> debuggerInterpreter: aDASTEvaluator [ 
	debuggerInterpreter := aDASTEvaluator 

]

{ #category : #'accessing-specialObjects' }
EP2ObjectSpace >> falseObject [
	^ self backend falseObject
]

{ #category : #'accessing-specialObjects' }
EP2ObjectSpace >> falseObject: aFalseObject [
	self backend falseObject: aFalseObject
]

{ #category : #'from-local-to-mirror' }
EP2ObjectSpace >> fromLocalInteger: anInteger [

	^backend fromLocalInteger: anInteger
]

{ #category : #accessing }
EP2ObjectSpace >> interpreter [
	interpreter ifNil: [ self error: 'interpreter not initialized for this object space' ].
	^interpreter
]

{ #category : #accessing }
EP2ObjectSpace >> interpreter: anEPASTEvaluator [ 
	interpreter := anEPASTEvaluator 

]

{ #category : #'remote-objects-instantiation' }
EP2ObjectSpace >> newRemoteArrayWithAll: elements [
	
	| array |
	array := self backend arrayClass basicNew: elements size.
	elements withIndexDo: [ :element :index |
		array at: index put: element
	].
	^ array
]

{ #category : #'accessing-specialObjects' }
EP2ObjectSpace >> nilObject [
	^ self backend nilObject
]

{ #category : #'accessing-specialObjects' }
EP2ObjectSpace >> nilObject: aNilObject [
	self backend nilObject: aNilObject
]

{ #category : #'accessing-specialObjects' }
EP2ObjectSpace >> specialObjectsArray [
	^ specialObjectsArray 
]

{ #category : #'accessing-specialObjects' }
EP2ObjectSpace >> specialObjectsArray: anEP2Mirror [ 
	specialObjectsArray := anEP2Mirror.
	backend simulator objectMemory specialObjectsOop: anEP2Mirror target address
]

{ #category : #accessing }
EP2ObjectSpace >> symbolTable: anEPExternalSymbolTable [ 
	symbolTable := anEPExternalSymbolTable 

]

{ #category : #'accessing-specialObjects' }
EP2ObjectSpace >> trueObject [
	^ self backend trueObject
]

{ #category : #'accessing-specialObjects' }
EP2ObjectSpace >> trueObject: aTrueObject [
	self backend trueObject: aTrueObject
]
