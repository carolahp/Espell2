Class {
	#name : #InstVarSlotsAspect,
	#superclass : #FieldAspect,
	#category : #Espell2Metamodel
}

{ #category : #'instance creation' }
InstVarSlotsAspect class >> buildDemoClassesIn: aLanguageModel [
	" adding classes and methods that use the field implemented "
	^ self
]

{ #category : #'instance creation' }
InstVarSlotsAspect class >> demoEntryPoint [ 
	^ '| p |
	p := Point new.
	(Point slotNamed: #x) write: 42 to: p.
	(Point slotNamed: #y) write: 12 to: p.
	System log: ((Point slotNamed: #x) read:p) asString.
	System log: ((Point slotNamed: #y) read:p) asString.
	System quit'
]

{ #category : #'instance creation' }
InstVarSlotsAspect class >> expectedEntryPointResult [
	^ '42
12'
]

{ #category : #accessing }
InstVarSlotsAspect >> fieldName [
	^ #mySlots
]

{ #category : #accessing }
InstVarSlotsAspect >> fieldValueFor: aClassModel [ 
	^ aClassModel slots
]

{ #category : #accessing }
InstVarSlotsAspect >> firstClassModelRoles [
	^ { InstanceVariableSlotModel }
]

{ #category : #binding }
InstVarSlotsAspect >> innerBindingOf: aSymbol in: aClassModel [
	^ nil
]

{ #category : #'model build' }
InstVarSlotsAspect >> transformClassModel: classModel [
	classModel
		addLocalMethodFromSource:
			'allSlots
			self superclass 
				ifNil: [ ^ mySlots asOrderedCollection ].
			^ self superclass allSlots asOrderedCollection
				addAll: mySlots;
				asArray'
		selector: #allSlots.
	"classModel
		addLocalMethodFromSource:
			'slots
			^ slots'
		selector: #slots."
	classModel
		addLocalMethodFromSource:
			'slotNamed: aSymbol
			^ (self allSlots 
				select: [:slot | slot name = aSymbol asSymbol ]) anyOne'
		selector: #slotNamed:
]

{ #category : #'model build' }
InstVarSlotsAspect >> transformLanguageCustom: aLanguageModel [
	self transformObjectModel: aLanguageModel classProtoObject.
	self transformClassModel: aLanguageModel classClass.
	self transformSlotModel: (aLanguageModel classWithRole: #InstanceVariableSlot)
]

{ #category : #'model build' }
InstVarSlotsAspect >> transformObjectModel: objectModel [
	objectModel
		addLocalMethodFromSource:
			'writeSlot: aSlot value: anObject
	^aSlot write: anObject to: self'
		selector: #writeSlot:value:
]

{ #category : #'model build' }
InstVarSlotsAspect >> transformSlotModel: slotModel [
	slotModel
		addLocalMethodFromSource:
			'printOn: aStream
			aStream 
				nextPutAll: name;
				nextPutAll: '' => '';
				nextPutAll: self class name'
		selector: #printOn:.
	slotModel
		addLocalMethodFromSource:
			'name
				^ name'
		selector: #name.
	
	slotModel
		addLocalMethodFromSource:
			'read: anObject
			^ thisContext object: anObject instVarAt: index'
		selector: #read:.
	slotModel
		addLocalMethodFromSource:
			'write: aValue to: anObject
			^ thisContext object: anObject instVarAt: index put: aValue'
		selector: #write:to:.
	
]
