Class {
	#name : #EP2RemoteSystemDictionary,
	#superclass : #EP2RemoteDictionary,
	#category : #'Espell2-Kernel'
}

{ #category : #constants }
EP2RemoteSystemDictionary class >> modelInstSpec [
	^ 1
]

{ #category : #constants }
EP2RemoteSystemDictionary class >> modelInstVarNames [
	"I inherit #(#tally #array) from RemoteDictionary so I don't redefine them. Use modelAllInstVarNames to get all my inst vars"
	^ #()
]

{ #category : #constants }
EP2RemoteSystemDictionary class >> role [
	^ 'SystemDictionary'
]
