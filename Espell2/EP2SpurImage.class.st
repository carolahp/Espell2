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
		nilObject: anEP2Mirror;
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

{ #category : #'accessing-specialObjects' }
EP2SpurImage >> classTable [
	^ classTable
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
			[ :each | each allVariables  ]
]

{ #category : #initialization }
EP2SpurImage >> initialize [
	super initialize.
	self initializeSpecialObjects 
]

{ #category : #initialization }
EP2SpurImage >> initializeSpecialObjects [
	| classes |
	
	falseObject := nilObject nextObject.
	trueObject := falseObject nextObject.
	specialObjectsArray := self backend specialObjectsArray.
	"calculating class table"
	classes := #() asOrderedCollection.
	self backend simulator objectMemory 
		classTableObjectsDoWithIndex: [ :classOop :index | 
			classes add: { index . (self backend mirrorOnAddress: classOop) asRemoteClass } ].
	classes sort: [ :c1 :c2 | ((c1 at:2) classNameFromAnyOrigin) < ((c2 at:2) classNameFromAnyOrigin) ].
	classTable := classes asArray asRemoteObjectInObjectSpace: self objectSpace
]

{ #category : #'accessing-specialObjects' }
EP2SpurImage >> nilObject [ 
	^ nilObject
]

{ #category : #'accessing-specialObjects' }
EP2SpurImage >> nilObject: anEP2Mirror [
	nilObject := anEP2Mirror
]

{ #category : #accessing }
EP2SpurImage >> objectSpace [
	^ self backend interpreter objectSpace
]

{ #category : #'accessing-specialObjects' }
EP2SpurImage >> specialObjectsArray [
	^ specialObjectsArray
]

{ #category : #'accessing-specialObjects' }
EP2SpurImage >> trueObject [
	^ trueObject
]
