Class {
	#name : #MCandleExplicitMetaclassesClass,
	#superclass : #MExplicitMetaclassesClass,
	#instVars : [
		'name',
		'instVarNames',
		'classVariables'
	],
	#category : #'Espell2-Metamodel'
}

{ #category : #accessing }
MCandleExplicitMetaclassesClass >> classVariables [
	^ classVariables
]

{ #category : #accessing }
MCandleExplicitMetaclassesClass >> classVariables: aCollection [ 
	classVariables := aCollection
]

{ #category : #accessing }
MCandleExplicitMetaclassesClass >> extendWithMonticelloCustom: aMCClassDefinition [ 
	| mcDef |
	super extendWithMonticelloCustom: aMCClassDefinition.
	mcDef := aMCClassDefinition.
	self instVarNames: mcDef instVarNames.
	self classVariables: nil
]

{ #category : #accessing }
MCandleExplicitMetaclassesClass >> hookInstall [
	super hookInstall.
	
	self remote 
		name: (self toRemoteObject: self name asSymbol);
		instVarNames: (self toRemoteObject: self instVarNames asArray);
		classVariables: (self toRemoteObject: self classVariables).
	^ self remote
]

{ #category : #accessing }
MCandleExplicitMetaclassesClass >> initializeWithTemplateCustom: aTemplate [
	super initializeWithTemplateCustom: aTemplate.
	self instVarNames: aTemplate instVarNames. 
	self classVariables: nil
]

{ #category : #accessing }
MCandleExplicitMetaclassesClass >> instVarNames1 [
	^ instVarNames
]

{ #category : #accessing }
MCandleExplicitMetaclassesClass >> instVarNames: aCollection [ 
	instVarNames := aCollection
]

{ #category : #accessing }
MCandleExplicitMetaclassesClass >> testRemote [
	| remote remoteName remoteInstVars |
	super testRemote.
	remote := self remote.
	remoteName := (remote instanceVariableNamed: #name).
	self assert: remoteName isNotNilObject.
	self assert: remoteName basicClass = (self parent remote classNamed: #ByteSymbol).
	remoteInstVars := (remote instanceVariableNamed: #instVarNames).
	self assert: remoteInstVars isNotNilObject.
	self assert: remoteInstVars basicClass = (self parent remote classNamed: #Array)
]
