Class {
	#name : #EP2RemoteProcessorScheduler,
	#superclass : #EP2Remote,
	#category : #'Espell2-Kernel'
}

{ #category : #constants }
EP2RemoteProcessorScheduler class >> layoutClass [ 
	^ EP2FixedLayout 
]

{ #category : #constants }
EP2RemoteProcessorScheduler class >> modelInstSpec [
	^ 1
]

{ #category : #constants }
EP2RemoteProcessorScheduler class >> modelInstVarNames [ 
	^ #(#suspendedProcessLists #activeProcess)
]

{ #category : #constants }
EP2RemoteProcessorScheduler class >> role [ 
	^ #ProcessorScheduler
]

{ #category : #accessing }
EP2RemoteProcessorScheduler >> activeProcess [
	^ self instanceVariableAtIndex: self processSchedulerActiveProcessIndex
]

{ #category : #accessing }
EP2RemoteProcessorScheduler >> activeProcess: aRemoteProcess [ 
	self instanceVariableAtIndex: self processSchedulerActiveProcessIndex put: aRemoteProcess
]

{ #category : #converting }
EP2RemoteProcessorScheduler >> asRemoteScheduler [
	^ self
]

{ #category : #'inst-var mapping' }
EP2RemoteProcessorScheduler >> printOn: aStream [
	aStream 
		nextPutAll: '*a ProcessorScheduler*'
]

{ #category : #'inst-var mapping' }
EP2RemoteProcessorScheduler >> processSchedulerActiveProcessIndex [
	^ (self systemDefinition instanceVariableMapping processSchedulerActiveProcessIndex) ifNil: [ self class unmappedInstVarIndex ]
]

{ #category : #'as yet unclassified' }
EP2RemoteProcessorScheduler >> suspendedProcessList [
	^ self instanceVariableAtIndex: self suspendedProcessListIndex
]

{ #category : #'as yet unclassified' }
EP2RemoteProcessorScheduler >> suspendedProcessList: aRemoteArray [
	self instanceVariableAtIndex: self suspendedProcessListIndex put: aRemoteArray 
]

{ #category : #'as yet unclassified' }
EP2RemoteProcessorScheduler >> suspendedProcessListIndex [
	^ 1
]
