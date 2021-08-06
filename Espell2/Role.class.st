Class {
	#name : #Role,
	#superclass : #Object,
	#instVars : [
		'name',
		'objectModel'
	],
	#category : #'Espell2-Roles'
}

{ #category : #constants }
Role class >> defaultClassRoles [
	" get roles from EP2Remote subclasses"

	| templates |
	templates := EP2Remote allSubclasses
		add: EP2Remote;
		yourself.
	^ templates collect: #role thenSelect: #isNotNil
]

{ #category : #'bootstrap roles' }
Role class >> defaultClassRolesFor: aLanguageModel [
	| metamodelRoles roles |
	metamodelRoles := aLanguageModel class usedModels
		collect: #role
		thenSelect: #isNotNil.
	self
		assert: metamodelRoles asSet size = metamodelRoles size
		description: 'same role defined for more than one ObjectModel class'.
	metamodelRoles addAll: self defaultClassRoles.
	^ (metamodelRoles asSet collect: [ :each | each -> each ]) asDictionary
]

{ #category : #instantiation }
Role class >> named: aString for: anObjectModel [
	| roleClass |
	roleClass := (aString ~= #Class and: [self defaultClassRoles includes: aString])
		ifTrue: [ Role ]
		ifFalse: [ RoleCustom ].
	^ roleClass basicNew
		name: aString;
		objectModel: anObjectModel;
		initialize;
		yourself
]

{ #category : #destroy }
Role >> destroy [ 
	objectModel := nil.
	name := nil
]

{ #category : #constants }
Role >> index2InClassTable [
	^ self templateClass index2InClassTable 
]

{ #category : #constants }
Role >> indexInClassTable [
	^ self templateClass indexInClassTable 
]

{ #category : #constants }
Role >> indexInSpecialObjectsArray [
	^ self templateClass indexInSpecialObjectsArray 
]

{ #category : #testing }
Role >> isImmediate [
	^ objectModel language immediateClassRoles
		anySatisfy: [ :rol | rol = name ]
]

{ #category : #accessing }
Role >> layoutClass [ 
	^ self templateClass layoutClass
]

{ #category : #testing }
Role >> modelAcceptsExtraInstVars [
	^ self templateClass modelAcceptsExtraInstVars 
]

{ #category : #constants }
Role >> modelInstSpec [
	^ self templateClass modelInstSpec 
]

{ #category : #accessing }
Role >> modelInstVarNames [
	
	^ self templateClass modelInstVarNames 
]

{ #category : #accessing }
Role >> name [ 
	^ name
]

{ #category : #accessing }
Role >> name: aString [ 
	name := aString
]

{ #category : #accessing }
Role >> objectModel: anObjectModel [ 
	objectModel := anObjectModel
]

{ #category : #accessing }
Role >> templateClass [ 
	| result |
	result := EP2Remote allSubclasses
		select: [ :aTemplate | aTemplate role = name ].
	result ifEmpty: [ ^ nil ].
	self
		assert: result size = 1
		description: 'role "' , name , '" defined by more than one EP2Remote subclass'.
	
	^ result anyOne
]

{ #category : #tests }
Role >> test: aClassModel [
	self testFormat: aClassModel.
	self testInstanceVariables: aClassModel.
]

{ #category : #tests }
Role >> testFormat: aClassModel [
	| modelInstSpec correctInstSpec |
	modelInstSpec := aClassModel instSpec.
	correctInstSpec := self modelInstSpec.
	self
		assert:
			(modelInstSpec = correctInstSpec
				or: (correctInstSpec = 1 and: modelInstSpec = 0))
		description:
			'Wrong instSpec in class "' , aClassModel name , '" (role "'
				, self name , '"). It should be ' , correctInstSpec asString
				, ' but it is ' , modelInstSpec asString.
	self
		assert: self modelInstVarNames size <= aClassModel instSize
		description:
			'Number of instance variables in class "' , aClassModel name
				, '" (role "' , self name , '"). do not match its instSize value'
]

{ #category : #tests }
Role >> testInstanceVariables: aClassModel [
	| modelInstVars roleInstVars |
	roleInstVars := self modelInstVarNames.
	roleInstVars
		doWithIndex: [ :ivName :index | 
			self
				assert: (aClassModel instVarIndexFor: ivName ifAbsent: [ 0 ]) = index
				description:
					'Instance variable "' , ivName , '" should be in position '
						, index asString , ' in class ' , aClassModel name , ' (role "'
						, self name , '") ' ].
	self modelAcceptsExtraInstVars
		ifTrue: [ ^ self ].
	modelInstVars := aClassModel allInstVarNames.
	self
		assert: modelInstVars size = roleInstVars size
		description:
			self name , ' should define the next inst vars exactly '
				, roleInstVars asString
]
