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
	" generic layout "
	^ EP2VariableLayout
]

{ #category : #printing }
EP2RemoteArray >> printOn: aStream [
	aStream nextPutAll: '#('.
	(1 to: self basicSize) do: [ :i | (self at: i) printOn: aStream . aStream nextPutAll: ' ' ].
	aStream nextPutAll: ')'
]
