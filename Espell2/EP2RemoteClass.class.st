Class {
	#name : #EP2RemoteClass,
	#superclass : #EP2RemoteObject,
	#category : #'Espell2-Kernel'
}

{ #category : #accessing }
EP2RemoteClass >> addressDefinitionMap [
	^ self backend objectSpace interpreter codeProvider classLoader addressDefinitionMap
]

{ #category : #'accessing-instVars' }
EP2RemoteClass >> allInstVars [
	^ (self allSlots select: #isInstanceVariableSlot) collect: [ :slot | slot name -> (slot read: self) ]
]

{ #category : #converting }
EP2RemoteClass >> asClassInSystemDefinition [
	^ [self addressDefinitionMap at: self target address ] on: KeyNotFound do: [ nil ]
]

{ #category : #'high-level-messages' }
EP2RemoteClass >> basicNew [
	
	^ self backend basicNewOn: self 
]

{ #category : #'high-level-messages' }
EP2RemoteClass >> basicNew: aSize [ 
	^ self backend basicNewOn: self withSize: aSize
]

{ #category : #'high-level-message' }
EP2RemoteClass >> basicSetClassName: aString [ 
	self instanceVariableAtIndex: self classNameIndex put: aString
]

{ #category : #'instVars-mapping' }
EP2RemoteClass >> classFormatIndex [
	^ (self systemDefinition instanceVariableMapping classFormatIndex) ifNil: [ self error: 'undefined index for format inst var in Class' ]
]

{ #category : #'accessing-specialInstVars' }
EP2RemoteClass >> className [
	| remoteName |
	remoteName := [self instanceVariableAtIndex: self classNameIndex] on: SubscriptOutOfBounds do: [ ^ nil ].
	remoteName isNilObject ifTrue: [^nil].
	^ self backend fromRemoteByteSymbol: remoteName
]

{ #category : #accessing }
EP2RemoteClass >> classNameFromAnyOrigin [
	^ self className 
		ifNil: [ self asClassInSystemDefinition 
					ifNil: [ 'error (', self mirror asString,')' ] 
					ifNotNil: [:classDef | classDef name] ]
]

{ #category : #'instVars-mapping' }
EP2RemoteClass >> classNameIndex [
	^ (self systemDefinition instanceVariableMapping classNameIndex) ifNil: [ self class unmappedInstVarIndex ]
]

{ #category : #'accessing-specialInstVars' }
EP2RemoteClass >> classPool [
	^ self instanceVariableAtIndex: self classPoolIndex
]

{ #category : #'high level messages' }
EP2RemoteClass >> classPool: anObject [ 
	
	^ self instanceVariableAtIndex: self classPoolIndex put: anObject asRemoteObject
]

{ #category : #'instVars-mapping' }
EP2RemoteClass >> classPoolIndex [
	^ (self backend systemDefinition instanceVariableMapping classPoolIndex) ifNil: [ self class unmappedInstVarIndex ]
]

{ #category : #'instVars-mapping' }
EP2RemoteClass >> classSharedPoolsIndex [
	^ (self systemDefinition instanceVariableMapping classSharedPoolsIndex) ifNil: [ self class unmappedInstVarIndex ]
]

{ #category : #'high-level-messages' }
EP2RemoteClass >> classSide [
	^ self basicClass
]

{ #category : #'instVars-mapping' }
EP2RemoteClass >> classSuperclassIndex [
	^ (self systemDefinition instanceVariableMapping classSuperclassIndex) ifNil: [ self error: 'undefined index for superclass inst var in Class' ]
]

{ #category : #'accessing-header' }
EP2RemoteClass >> compactClassIndex [
	^ self backend compactClassIndexOf: self
	
]

{ #category : #'accessing-header' }
EP2RemoteClass >> format [
	^self layout instanceVariableAtIndex: self classFormatIndex 
]

{ #category : #'accessing-specialInstVars' }
EP2RemoteClass >> format: anInteger [
	^self layout instanceVariableAtIndex: self classFormatIndex put: anInteger
]

{ #category : #'gt-inspector' }
EP2RemoteClass >> gtInspectorIn: composite [
	<gtInspectorPresentationOrder: 2>
	^ self layout gtInspectorIn: composite
]

{ #category : #binding }
EP2RemoteClass >> innerBindingOf: aSymbol [ 
	(self classPool isNilObject) ifFalse: [ self halt ].
	(self sharedPool isNilObject) ifFalse: [ self halt ].
	self flag: 'superclass is nil for all stubs, check this later'.
	(self superclass isNilObject) ifFalse:  [^ self superclass innerBindingOf: aSymbol].
	^ nil
]

{ #category : #'accessing-specialInstVars' }
EP2RemoteClass >> instSpec [ 
	^ self backend instSpecOfClass: self mirror
]

{ #category : #'high-level-messages' }
EP2RemoteClass >> instanceFixedSize [
	
	^ self backend instanceFixedSizeOf: self
]

{ #category : #testing }
EP2RemoteClass >> isBitsClass [

	^ self backend isBitsClass: self
	
]

{ #category : #testing }
EP2RemoteClass >> isRemoteClass [
	^ true
]

{ #category : #testing }
EP2RemoteClass >> isRoleMetaclass [
	^ self backend isRoleMetaclass: self
]

{ #category : #'accessing-specialInstVars' }
EP2RemoteClass >> layoutClass [
	" generic layout "
	^ EP2FixedLayout
]

{ #category : #printing }
EP2RemoteClass >> printOn: aStream [
	aStream 
		nextPutAll: '*';
		nextPutAll: self classNameFromAnyOrigin;
		nextPutAll: '*'
]

{ #category : #'accessing-slots' }
EP2RemoteClass >> readSlotNamed: aName [
	^ (self slotNamed: aName) read: self 
]

{ #category : #'accessing-specialInstVars' }
EP2RemoteClass >> sharedPool [
	^ self instanceVariableAtIndex: self classSharedPoolsIndex 
]

{ #category : #'accessing-slots' }
EP2RemoteClass >> slotNamed: aString [ 
	^ (self allSlots select: [ :slot | slot name = aString ]) anyOne
]

{ #category : #'accessing-specialInstVars' }
EP2RemoteClass >> superclass [
	^ self instanceVariableAtIndex: self classSuperclassIndex 
]
