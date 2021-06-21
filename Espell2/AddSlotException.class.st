Class {
	#name : #AddSlotException,
	#superclass : #Exception,
	#category : #'Espell2-Kernel-Layouts'
}

{ #category : #accessing }
AddSlotException >> defaultAction [
	UnhandledError signalForException: self
]
