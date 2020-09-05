Class {
	#name : #EP2SpurImage,
	#superclass : #Object,
	#instVars : [
		'nilObject',
		'trueObject',
		'falseObject',
		'specialObjectsArray',
		'classTable'
	],
	#category : #'Espell2-Image'
}

{ #category : #instantiation }
EP2SpurImage class >> onFirstObject: anEP2Mirror [
	^ self basicNew 
		nilObject: anEP2Mirror asRemoteNil;
		initialize;
		yourself
]

{ #category : #'accessing-slots' }
EP2SpurImage >> allVariables [
	^ { nilObject . falseObject . trueObject . specialObjectsArray . classTable }
]

{ #category : #accessing }
EP2SpurImage >> backend [ 
	^ self nilObject backend 
]

{ #category : #'accessing-classes' }
EP2SpurImage >> classNamed: aString [
	(self classes select: [ :class | class name = aString ]) 
		ifNotEmpty: [ :result | ^ result anyOne ].
	^ nil
]

{ #category : #'accessing-specialObjects' }
EP2SpurImage >> classTable [
	^ classTable
]

{ #category : #'accessing-classes' }
EP2SpurImage >> classes [
	| classes |
	classes := #() asOrderedCollection.
	self classesOopDoWithIndex: [ :classOop :index |
		classes add: (self backend mirrorOnAddress: classOop) asRemoteClass ].
	^ classes
]

{ #category : #'accessing-classes' }
EP2SpurImage >> classesOop [
	| classes |
	classes := #() asOrderedCollection.
	self classesOopDoWithIndex: [ :class :index |
		classes add: class ].
	^ classes
]

{ #category : #'accessing-classes' }
EP2SpurImage >> classesOopDoWithIndex: aBlock [ 
	^ self backend simulator objectMemory classTableObjectsDoWithIndex: aBlock 
]

{ #category : #'accessing-specialObjects' }
EP2SpurImage >> falseObject [

	^ falseObject
]

{ #category : #'gt-inspector' }
EP2SpurImage >> gtInspector: composite [
	<gtInspectorPresentationOrder: 1>
	
	^ composite tree
		rootsExpanded;
		title: 'Remote Image';
		display: [ { self } ];
		children: 
			[ :each | each allVariables collect: #asRemoteObjectCasted ]
]

{ #category : #'gt-inspector' }
EP2SpurImage >> gtInspectorClassTable: composite [
	<gtInspectorPresentationOrder: 2>
	^ composite table
		title: 'Class Table';
		display: [ 
			self classTable
				localCollect: [ :row | 
					| class |
					class := (row at: 2) asRemoteClass.
					{(row at: 1) .
					class classTableIndex .
					class} ] ];
		column: 'index' evaluated: [ :array | array at: 1 ];
		column: 'tag' evaluated: [ :array | array at: 2 ];
		column: 'class' evaluated: [ :array | array at: 3 ];
		send: [ :array | array ifNotNil: [ array at: 3 ] ]
]

{ #category : #'gt-inspector' }
EP2SpurImage >> gtInspectorLoadedClasses: composite [
	<gtInspectorPresentationOrder: 3>
	^ composite table
		title: 'Loaded classes';
		display: [ self backend systemDefinition allClasses
				collect: [ :class | 
					| remoteClass |
					remoteClass := class remote.
					(remoteClass isNil or: [remoteClass isNilObject])
						ifTrue: [ {class name.
							nil.
							class remote} ]
						ifFalse: [ {class name.
							remoteClass classTableIndex.
							remoteClass} ] ] ];
		column: 'name' evaluated: [ :array | array at: 1 ];
		column: 'tag' evaluated: [ :array | array at: 2 ];
		column: 'remote' evaluated: [ :array | array at: 3 ];
		send: [ :array | array ifNotNil: [ array at: 3 ] ]
]

{ #category : #initialization }
EP2SpurImage >> initialize [
	super initialize.
	self initializeSpecialObjects 
]

{ #category : #initialization }
EP2SpurImage >> initializeSpecialObjects [
	| classes |
	falseObject := nilObject nextObject asRemoteFalse.
	trueObject := falseObject nextObject asRemoteTrue.
	specialObjectsArray := self backend specialObjectsArray asRemoteArray.
	"calculating class table"
	classes := #() asOrderedCollection.
	self
		classesOopDoWithIndex: [ :classOop :index | 
			| val |
			val := (self backend mirrorOnAddress: classOop) asRemoteClass.
			classes
				add: ({index .	val} asRemoteObjectInObjectSpace: self objectSpace) asRemoteArray ].
	classes
		sort:
			[ :c1 :c2 | (c1 at: 2) asRemoteClass classNameFromAnyOrigin < (c2 at: 2) asRemoteClass classNameFromAnyOrigin ].
	classTable := (classes asArray
		asRemoteObjectInObjectSpace: self objectSpace) asRemoteArray
]

{ #category : #'accessing-specialObjects' }
EP2SpurImage >> nilObject [ 
	^ nilObject
]

{ #category : #'accessing-specialObjects' }
EP2SpurImage >> nilObject: anEP2Mirror [
	nilObject := anEP2Mirror asRemoteNil
]

{ #category : #accessing }
EP2SpurImage >> objectSpace [
	^ self backend interpreter objectSpace
]

{ #category : #'accessing-specialObjects' }
EP2SpurImage >> specialObjectsArray [
	^ specialObjectsArray
]

{ #category : #testing }
EP2SpurImage >> test [
	self testClasses.
	self testMethods.
	self testProcess
]

{ #category : #testing }
EP2SpurImage >> testClasses [
	self classTable do: [ :assoc | | class | 
		class := assoc asRemoteAssociation value asRemoteClass.
		class test.
		class basicClass test.
		class superclass test. ]
]

{ #category : #testing }
EP2SpurImage >> testStub [
	self classTable do: [ :assoc | | class | 
		class := assoc asRemoteAssociation value.
		class asRemoteClass testStub ]
]

{ #category : #'accessing-specialObjects' }
EP2SpurImage >> trueObject [
	^ trueObject
]
