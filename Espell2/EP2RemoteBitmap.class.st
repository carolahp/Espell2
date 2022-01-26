Class {
	#name : #EP2RemoteBitmap,
	#superclass : #EP2RemoteArrayedCollection,
	#category : #'Espell2-Kernel'
}

{ #category : #constants }
EP2RemoteBitmap class >> layoutClass [ 
	^ EP2WordLayout 
]

{ #category : #constants }
EP2RemoteBitmap class >> modelInstSpec [
	^ 10
]

{ #category : #constants }
EP2RemoteBitmap class >> modelInstVarNames [
	^ #()
]

{ #category : #constants }
EP2RemoteBitmap class >> role [ 
	^ #Bitmap
]
