Class {
	#name : #EP2RemoteByteArray,
	#superclass : #EP2RemoteArrayedCollection,
	#category : #'Espell2-Kernel'
}

{ #category : #constants }
EP2RemoteByteArray class >> layoutClass [
	^ EP2ByteLayout 
]

{ #category : #constants }
EP2RemoteByteArray class >> modelInstSpec [
	^ 16
]

{ #category : #'instance creation' }
EP2RemoteByteArray class >> newWithSize: anInteger withBackend: anEP2Backend [ 
	^ anEP2Backend basicNewOn: anEP2Backend byteArrayClass withSize: anInteger
]

{ #category : #constants }
EP2RemoteByteArray class >> role [ 
	^'ByteArray'
]

{ #category : #'gt-inspector' }
EP2RemoteByteArray >> gtInspector2RawIn: composite [
	<gtInspectorPresentationOrder: 2>
	^ self layout gtInspectorRawIn: composite

]
