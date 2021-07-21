Class {
	#name : #EP2RemoteProcessList,
	#superclass : #EP2Remote,
	#category : #'Espell2-Kernel'
}

{ #category : #constants }
EP2RemoteProcessList class >> layoutClass [ 
	^ EP2FixedLayout 
]

{ #category : #constants }
EP2RemoteProcessList class >> modelInstSpec [
	^ 1
]

{ #category : #constants }
EP2RemoteProcessList class >> modelInstVarNames [ 
	^ #(#firstLink #lastLink)
]

{ #category : #constants }
EP2RemoteProcessList class >> role [ 
	^ 'ProcessList'
]
