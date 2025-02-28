Class {
	#name : #ASDPORCrudGeneratorPage,
	#superclass : #ASDPORPageModules,
	#category : #'AsdPharoIde-Core-Web'
}

{ #category : #accessing }
ASDPORCrudGeneratorPage class >> pageName [
	^ 'CRUD Genarator'
]

{ #category : #accessing }
ASDPORCrudGeneratorPage class >> priority [
	^ 3
]

{ #category : #initialize }
ASDPORCrudGeneratorPage >> initialize [
	super initialize.

	
]

{ #category : #rendering }
ASDPORCrudGeneratorPage >> renderContentOn: html [
	html mdlGrid
		shadow: 0;
		style: 'align-items: center; height: 100%';
		with: [ html mdlCell
				middle;
				size: 12;
				with: [  ] ]
]
