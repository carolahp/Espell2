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
				with: [ spec repository: 'github://carolahp/espell:Pharo10' ].
			spec
				baseline: 'Phantom'
				with: [ spec repository: 'github://carolahp/PHANtom:v1.0.0' ].
			spec package: 'Espell2' ]
]
