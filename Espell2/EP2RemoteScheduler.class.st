Class {
	#name : #EP2RemoteScheduler,
	#superclass : #EP2RemoteObject,
	#category : #'Espell2-Kernel'
}

{ #category : #accessing }
EP2RemoteScheduler >> activeProcess [
	^ self instanceVariableAtIndex: self processSchedulerActiveProcessIndex
]

{ #category : #accessing }
EP2RemoteScheduler >> activeProcess: aRemoteProcess [ 
	self instanceVariableAtIndex: self processSchedulerActiveProcessIndex put: aRemoteProcess
]

{ #category : #'inst-var mapping' }
EP2RemoteScheduler >> processSchedulerActiveProcessIndex [
	^ (self systemDefinition instanceVariableMapping processSchedulerActiveProcessIndex) ifNil: [ self class unmappedInstVarIndex ]
]
