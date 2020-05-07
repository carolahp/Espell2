Class {
	#name : #EP2RemoteClass,
	#superclass : #EP2RemoteObject,
	#category : #'Espell2-HighLevel-remoteObjects'
}

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
	
	^ self backend 
		fromRemoteByteSymbol: (self instanceVariableAtIndex: self classNameIndex)
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
	^(self instanceVariableAtIndex: self classFormatIndex) asLocalSmallInteger
]

{ #category : #'accessing-specialInstVars' }
EP2RemoteClass >> format: anInteger [
	^ self 
		instanceVariableAtIndex: self classFormatIndex
		put: anInteger
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

{ #category : #accessing }
EP2RemoteClass >> layoutClass [
	" generic layout "
	^ EP2FixedLayout
]

{ #category : #printing }
EP2RemoteClass >> printOn: aStream [
	aStream 
		nextPutAll: '*';
		nextPutAll: self className;
		nextPutAll: '*'
]
