Class {
	#name : #EP2RemoteArray,
	#superclass : #EP2RemoteObject,
	#category : #'Espell2-Kernel'
}

{ #category : #accessing }
EP2RemoteArray class >> at: index put: value [ 
	^ self layout at: index put: value
]

{ #category : #accessing }
EP2RemoteArray >> layoutClass [
	^ EP2VariableLayout
]

{ #category : #printing }
EP2RemoteArray >> printOn: aStream [
	aStream nextPutAll: '*a ';
		nextPutAll: self basicClass classNameFromAnyOrigin, ' [';
		nextPutAll: self basicSize asString;
		nextPutAll:' items]*'
]

{ #category : #'accessing-slots' }
EP2RemoteArray >> slotNamed: aString [ 
	^ (self allSlots select: [ :slot | slot name = aString ]) anyOne
]
