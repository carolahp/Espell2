"
I hold references to objects installed in the bootstrapped Object Memory
"
Class {
	#name : #EP2InternalObjectHandle,
	#superclass : #EP2Handle,
	#category : #'Espell2-Handles'
}

{ #category : #comparing }
EP2InternalObjectHandle >> = aHandle [

	^ self species = aHandle species
		and: [ self address == aHandle address ]
]

{ #category : #accessing }
EP2InternalObjectHandle >> address [ 
	self subclassResponsibility 
]

{ #category : #converting }
EP2InternalObjectHandle >> asSmallInteger [
	
	^ backend integerValueOf: self
]

{ #category : #accessing }
EP2InternalObjectHandle >> basicRemoteClassHandle [
	^ self basicClassHandle
]

{ #category : #'accessing-instVars' }
EP2InternalObjectHandle >> basicSize [ 
	^ backend basicSizeOf: self
]

{ #category : #'high-level-message' }
EP2InternalObjectHandle >> instSpec [
	"we assume this method is called only when I point to a class. Otherwise this will fail in the assertions done by the vm simulator"
	^ backend instSpecOfClass: self
]

{ #category : #'accessing-instVars' }
EP2InternalObjectHandle >> instanceVariableAtIndex: anInteger [ 
	
	^ backend object: self address instVarAt: anInteger
]

{ #category : #testing }
EP2InternalObjectHandle >> isClassTableHandler [
	^ false
]

{ #category : #accessing }
EP2InternalObjectHandle >> isExternalHandle [
	^ false
]

{ #category : #'as yet unclassified' }
EP2InternalObjectHandle >> isSmallInteger [
	^ backend isSmallInteger: self
]

{ #category : #'as yet unclassified' }
EP2InternalObjectHandle >> species [

	^ EP2InternalObjectHandle
]

{ #category : #accessing }
EP2InternalObjectHandle >> target [ 
	^ self 
]
