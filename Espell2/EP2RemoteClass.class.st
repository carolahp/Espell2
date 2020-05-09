Class {
	#name : #EP2RemoteClass,
	#superclass : #EP2RemoteObject,
	#category : #'Espell2-Kernel'
}

{ #category : #'accessing-slots' }
EP2RemoteClass >> allSlots [
	^ self layout allSlots
]

{ #category : #converting }
EP2RemoteClass >> asClassInSystemDefinition [
	^ self mirrorDefinitionMap at: self 
]

{ #category : #'high-level-messages' }
EP2RemoteClass >> basicNew [
	
	^ self backend basicNewOn: self
]

{ #category : #'high-level-message' }
EP2RemoteClass >> basicNew: aSize [ 
	^ self backend basicNewOn: self withSize: aSize
]

{ #category : #'accessing-instVars-mapping' }
EP2RemoteClass >> classFormatIndex [
	^ self systemDefinition classFormatIndex
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
	^ self className ifNil: [ self asClassInSystemDefinition name ]
]

{ #category : #'accessing-instVars-mapping' }
EP2RemoteClass >> classNameIndex [
	^ self backend systemDefinition instanceVariableMapping classNameIndex
]

{ #category : #'high-level-messages' }
EP2RemoteClass >> classSide [
	^ self basicClass
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

{ #category : #'accessing-specialInstVars' }
EP2RemoteClass >> instSpec [ 
	^ self backend instSpecOfClass: self mirror
]

{ #category : #'high-level-messages' }
EP2RemoteClass >> instanceFixedSize [
	
	^ self backend instanceFixedSizeOf: self.
]

{ #category : #testing }
EP2RemoteClass >> isBitsClass [

	^ self backend isBitsClass: self
	
]

{ #category : #testing }
EP2RemoteClass >> isRemoteClass [
	^ true
]

{ #category : #accessing }
EP2RemoteClass >> layoutClass [
	" generic layout "
	^ EP2FixedLayout
]

{ #category : #accessing }
EP2RemoteClass >> mirrorDefinitionMap [
	^ self backend objectSpace interpreter codeProvider classLoader mirrorDefinitionMap 
]

{ #category : #printing }
EP2RemoteClass >> printOn: aStream [
	aStream 
		nextPutAll: '*';
		nextPutAll: self classNameFromAnyOrigin;
		nextPutAll: '*'
]

{ #category : #'accessing-slots' }
EP2RemoteClass >> slotNamed: aString [ 
	^ (self allSlots select: [ :slot | slot name = aString ]) anyOne
]
