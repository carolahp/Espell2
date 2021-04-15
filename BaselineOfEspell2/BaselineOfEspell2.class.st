Class {
	#name : #BaselineOfEspell2,
	#superclass : #BaselineOf,
	#category : #BaselineOfEspell2
}

{ #category : #baselines }
BaselineOfEspell2 >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec blessing: #baseline.
			spec
				baseline: 'Espell'
				with: [ spec repository: 'github://carolahp/espell:simpleAPI' ].
			spec
				baseline: 'DebuggableASTInterpreter'
				with: [ spec repository: 'github://carolahp/DebuggableASTInterpreter:compatibility-espell2' ].
			
			spec package: 'Espell2' ].
		

]