"
I am a role defined by the user in its metamodel.
I include the role #Class 
"
Class {
	#name : #RoleCustom,
	#superclass : #Role,
	#category : #'Espell2-Roles'
}

{ #category : #constants }
RoleCustom >> index2InClassTable [
	^ nil
]

{ #category : #constants }
RoleCustom >> indexInClassTable [
	^ nil
]

{ #category : #constants }
RoleCustom >> indexInSpecialObjectsArray [
	^ nil
]

{ #category : #constants }
RoleCustom >> initialize [
	super initialize.
	self
		assert: self modelClass isNotNil
		description: 'undefined role "' , name , '". Define it in your subclass of ClassModel class>>role'.
	self templateClass
		ifNotNil: [ :template | 
			self
				assert: (self modelInstVarNames beginsWith: template modelInstVarNames)
				description:
					'role ' , name , ' inst vars should be defined in class '
						, self modelClass asString ]
]

{ #category : #constants }
RoleCustom >> layoutClass [
	^ self modelClass defaultLayout
]

{ #category : #constants }
RoleCustom >> modelAcceptsExtraInstVars [
	^ false 
]

{ #category : #accessing }
RoleCustom >> modelClass [
	| result |
	result := (objectModel language class usedModels
		select: [ :aMetamodel | aMetamodel role = name ]) ifEmpty: [ ^ nil ].
	self
		assert: result size = 1
		description: 'role "' , name , '" defined by more than one ObjectModel class'.
	^ result anyOne
]

{ #category : #constants }
RoleCustom >> modelInstSpec [
	^ self layoutClass instSpec 
]

{ #category : #constants }
RoleCustom >> modelInstVarNames [ 
	^ self modelClass allClassModelInstVarNames.
]
