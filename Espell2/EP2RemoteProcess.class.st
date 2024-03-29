Class {
	#name : #EP2RemoteProcess,
	#superclass : #EP2Remote,
	#category : #'Espell2-Kernel'
}

{ #category : #'instance creation' }
EP2RemoteProcess class >> createProcessForContext: aRemoteContext andPriority: aPriority inObjectSpace: anObjectSpace [ 
	| newProcess |
	newProcess := anObjectSpace backend processClass asClassMirror basicNew asRemoteProcess.
	newProcess priority: aPriority.
	newProcess context: aRemoteContext.
	^newProcess
]

{ #category : #constants }
EP2RemoteProcess class >> indexInSpecialObjectsArray [
	^ 28
]

{ #category : #constants }
EP2RemoteProcess class >> layoutClass [ 
	^ EP2FixedLayout 
]

{ #category : #constants }
EP2RemoteProcess class >> modelInstSpec [
	^ 1
]

{ #category : #constants }
EP2RemoteProcess class >> modelInstVarNames [ 
	^ #(#nextLink #suspendedContext #priority #myList #threadId #errorHandler)
]

{ #category : #constants }
EP2RemoteProcess class >> role [ 
	^ #Process
]

{ #category : #accessing }
EP2RemoteProcess >> asRemoteObjectCasted [
	^ self
]

{ #category : #accessing }
EP2RemoteProcess >> asRemoteProcess [
	^ self
]

{ #category : #accessing }
EP2RemoteProcess >> context [
	^ self instanceVariableAtIndex: self processContextIndex
]

{ #category : #accessing }
EP2RemoteProcess >> context: anEP2RemoteContext [ 
	self 
		instanceVariableAtIndex: self processContextIndex
		put: anEP2RemoteContext 
]

{ #category : #printing }
EP2RemoteProcess >> printOn: aStream [
	aStream 
		nextPutAll: '*a Process*'
]

{ #category : #accessing }
EP2RemoteProcess >> priority: aPriorityInteger [

	self 
		instanceVariableAtIndex: self processPriorityIndex
		put: aPriorityInteger 
]

{ #category : #accessing }
EP2RemoteProcess >> priorityList: aRemoteObject [ 
	self instanceVariableAtIndex: self processPriorityListIndex put: aRemoteObject
]

{ #category : #'inst-var mapping' }
EP2RemoteProcess >> processContextIndex [
	^ (self systemDefinition instanceVariableMapping processContextIndex) ifNil: [ self class unmappedInstVarIndex ]
]

{ #category : #'inst-var mapping' }
EP2RemoteProcess >> processPriorityIndex [
	^ (self systemDefinition instanceVariableMapping processPriorityIndex) ifNil: [ self class unmappedInstVarIndex ]
]

{ #category : #'inst-var mapping' }
EP2RemoteProcess >> processPriorityListIndex [
	^ (self systemDefinition instanceVariableMapping processPriorityListIndex) ifNil: [ self class unmappedInstVarIndex ]
]
