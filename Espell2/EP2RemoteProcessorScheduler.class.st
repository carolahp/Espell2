Class {
	#name : #EP2RemoteProcessorScheduler,
	#superclass : #EP2RemoteObject,
	#category : #'Espell2-Kernel'
}

{ #category : #constants }
EP2RemoteProcessorScheduler class >> remoteInstSpec [
	^ 1
]

{ #category : #constants }
EP2RemoteProcessorScheduler class >> role [ 
	^ 'ProcessScheduler'
]

{ #category : #accessing }
EP2RemoteProcessorScheduler >> activeProcess [
	^ self instanceVariableAtIndex: self processSchedulerActiveProcessIndex
]

{ #category : #accessing }
EP2RemoteProcessorScheduler >> activeProcess: aRemoteProcess [ 
	self instanceVariableAtIndex: self processSchedulerActiveProcessIndex put: aRemoteProcess
]

{ #category : #'inst-var mapping' }
EP2RemoteProcessorScheduler >> processSchedulerActiveProcessIndex [
	^ (self systemDefinition instanceVariableMapping processSchedulerActiveProcessIndex) ifNil: [ self class unmappedInstVarIndex ]
]
