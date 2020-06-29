Class {
	#name : #EP2RemoteSymbol,
	#superclass : #EP2RemoteString,
	#category : #'Espell2-Kernel'
}

{ #category : #'converting-local' }
EP2RemoteSymbol >> asLocalString [
	^ self backend fromRemoteByteString: self.
]

{ #category : #accessing }
EP2RemoteSymbol >> layoutClass [
	^ EP2ByteLayout 
]
