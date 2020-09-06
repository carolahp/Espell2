Class {
	#name : #EP2RemoteByteString,
	#superclass : #EP2RemoteString,
	#category : #'Espell2-Kernel'
}

{ #category : #constants }
EP2RemoteByteString class >> layoutClass [ 
	^ EP2ByteLayout 
]

{ #category : #constants }
EP2RemoteByteString class >> modelInstSpec [
	^ 16
]

{ #category : #constants }
EP2RemoteByteString class >> modelInstVarNames [
	^ #()
]

{ #category : #constants }
EP2RemoteByteString class >> role [ 
	^ 'ByteString'
]

{ #category : #'gt-extension' }
EP2RemoteByteString >> gtInspectorRaw2In: composite [ 
	<gtInspectorPresentationOrder: 2>
	^ self layout gtInspectorRawIn: composite
]
