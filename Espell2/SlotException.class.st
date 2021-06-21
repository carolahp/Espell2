Class {
	#name : #SlotException,
	#superclass : #Exception,
	#category : #'Espell2-Kernel-Layouts'
}

{ #category : #accessing }
SlotException >> defaultAction [
	UnhandledError signalForException: self
]
