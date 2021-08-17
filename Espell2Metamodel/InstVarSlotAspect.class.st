Class {
	#name : #InstVarSlotAspect,
	#superclass : #FieldAspect,
	#category : #Espell2Metamodel
}

{ #category : #'instance creation' }
InstVarSlotAspect class >> buildDemoClassesIn: aLanguageModel [
	" adding classes and methods that use the field implemented "
	^ self
]

{ #category : #'instance creation' }
InstVarSlotAspect class >> demoEntryPoint [ 
	^ '| p |
	p := Point new.
	(Point slotNamed: #x) write: 42 to: p.
	(Point slotNamed: #y) write: 12 to: p.
	System log: ((Point slotNamed: #x) read:p) asString.
	System log: ((Point slotNamed: #y) read:p) asString.
	System quit'
]

{ #category : #'instance creation' }
InstVarSlotAspect class >> expectedEntryPointResult [
	^ '42
12'
]

{ #category : #accessing }
InstVarSlotAspect >> defaultFieldValue [
	self error: 'All values should be obtained from #fieldValueFor:'
]

{ #category : #accessing }
InstVarSlotAspect >> fieldName [
	^ #mySlots
]

{ #category : #accessing }
InstVarSlotAspect >> fieldValueFor: aClassModel [ 
	^ aClassModel slots
]

{ #category : #accessing }
InstVarSlotAspect >> firstClassModelRoles [
	^ { InstanceVariableSlotModel }
]

{ #category : #binding }
InstVarSlotAspect >> innerBindingOf: aSymbol in: aClassModel [
	^ nil
]

{ #category : #'model build' }
InstVarSlotAspect >> transformClassModel: classModel [
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
InstVarSlotAspect >> transformLanguageCustom: aLanguageModel [
	self transformObjectModel: aLanguageModel classProtoObject.
	self transformClassModel: aLanguageModel classClass.
	self transformSlotModel: (aLanguageModel classWithRole: #InstanceVariableSlot)
]

{ #category : #'model build' }
InstVarSlotAspect >> transformObjectModel: objectModel [
	objectModel
		addLocalMethodFromSource:
			'writeSlot: aSlot value: anObject
	^aSlot write: anObject to: self'
		selector: #writeSlot:value:
]

{ #category : #'model build' }
InstVarSlotAspect >> transformSlotModel: slotModel [
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
