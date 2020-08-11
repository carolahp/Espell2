Extension { #name : #MCClassDefinition }

{ #category : #'*Espell2' }
MCClassDefinition >> ensureEspellDefinitionIn: anOLObjVLisp [ 
	
	^ anOLObjVLisp addBehaviorFromMonticelloDefinition: self
]

{ #category : #'*Espell2' }
MCClassDefinition >> ensureEspellDefinitionIn: aEP2MLanguage package: anEP2MPackage [ 
	| def |
	def := self ensureEspellDefinitionIn: aEP2MLanguage.
	def package: anEP2MPackage.
	"def category: def tags first."
	^ def
]

{ #category : #'*Espell2' }
MCClassDefinition >> espell2LayoutType [

	^ (Dictionary newFrom: {	
		#compiledMethod -> EP2CompiledMethodLayout. 
		#bytes -> EP2ByteLayout. 
		#immediate -> EP2ImmediateLayout. 
		#words -> EP2WordLayout. 
		#week -> EP2WeakLayout.
		#variable -> EP2VariableLayout.
		"#ephemeron -> EP2EphemeronLayout."
		#normal -> EP2FixedLayout.
		#weak -> EP2WeakLayout.
	}) at: type.		

]
