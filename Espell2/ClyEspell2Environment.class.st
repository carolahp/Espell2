Class {
	#name : #ClyEspell2Environment,
	#superclass : #Object,
	#instVars : [
		'environment',
		'name'
	],
	#category : #'Espell2-Calypso'
}

{ #category : #scope }
ClyEspell2Environment >> asGlobalScopeIn: aNavigationEnvironment [

	
	^ClySystemEnvironmentScope of: self in: aNavigationEnvironment named: name
]

{ #category : #binding }
ClyEspell2Environment >> bindingOf: aSymbol [
	
	^ environment bindingOf: aSymbol
]

{ #category : #accessing }
ClyEspell2Environment >> classes [
	^ self environment allClasses
]

{ #category : #accessing }
ClyEspell2Environment >> environment [
	^ environment
]

{ #category : #accessing }
ClyEspell2Environment >> environment: anEP2MLanguage [ 
	environment := anEP2MLanguage
]

{ #category : #accessing }
ClyEspell2Environment >> name [
	^ name
]

{ #category : #accessing }
ClyEspell2Environment >> name: aString [ 
	name := aString
]

{ #category : #'accessing model' }
ClyEspell2Environment >> packages [

	^ environment packages
]

{ #category : #subscriptions }
ClyEspell2Environment >> subscribe: anObject [ 
	self subscribe: anObject for: SystemAnnouncement
]

{ #category : #subscription }
ClyEspell2Environment >> subscribe: anObject for: anAnnouncementClass [  
	self unsubscribe: anObject.
	environment announcer when: anAnnouncementClass send: #systemChanged: to: anObject
]

{ #category : #subscription }
ClyEspell2Environment >> unsubscribe: anObject [
	environment announcer unsubscribe: anObject
]

{ #category : #scope }
ClyEspell2Environment >> when: anAnnouncementClass send: aSelector to: anObject [
	self environment announcer when: anAnnouncementClass send: aSelector to: anObject
]
