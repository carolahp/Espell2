Class {
	#name : #EP2SpurImageTests,
	#superclass : #TestCase,
	#instVars : [
		'image'
	],
	#category : #'Espell2-Image'
}

{ #category : #'as yet unclassified' }
EP2SpurImageTests class >> runAllTestsOnSpurImage: anEP2SpurImage [
	| suite |
	suite := self buildSuite.
	suite tests do: [:item | item image: anEP2SpurImage].
	^ suite run
]

{ #category : #tests }
EP2SpurImageTests >> image: anEP2SpurImage [
	image := anEP2SpurImage
]

{ #category : #tests }
EP2SpurImageTests >> testFalse [
	image falseObject test
]

{ #category : #tests }
EP2SpurImageTests >> testNil [
	
	image nilObject test
]

{ #category : #tests }
EP2SpurImageTests >> testTrue [ 
	image trueObject test
]
