Class {
	#name : #ASDBPORHeaderPharoIde,
	#superclass : #ASDBPORHeader,
	#category : #'AsdPharoIde-ClassBrowser-Component'
}

{ #category : #rendering }
ASDBPORHeaderPharoIde >> renderAccountButtonOn: html [
	html
		mdlNavigation: [ html mdlButton icon
				id: #bottomLeftButton;
				with: [ html mdlIcon: #account_circle ].
			html mdlMenu
				bottomRight;
				for: #bottomLeftButton;
				with: [ html mdlMenuItem: 'Einstellungen'.
					html mdlMenuItem
						fullBleedDivider;
						with: 'Konto'.
					html mdlMenuItem
						disabled;
						with: 'Disabled Action'.
					html mdlMenuItem: 'Yet Another Action' ] ]
]

{ #category : #rendering }
ASDBPORHeaderPharoIde >> renderAddButtonOn: html [
	html
		mdlNavigation: [ html mdlButton icon
				id: #bottomLeftButton;
				with: [ html mdlIcon: #account_circle ].
			html mdlMenu
				bottomRight;
				for: #bottomLeftButton;
				with: [ html mdlMenuItem: 'Einstellungen'.
					html mdlMenuItem
						fullBleedDivider;
						with: 'Konto'.
					html mdlMenuItem
						disabled;
						with: 'Disabled Action'.
					html mdlMenuItem: 'Yet Another Action' ] ]
]

{ #category : #rendering }
ASDBPORHeaderPharoIde >> renderButtonsOn: html [
	self session isLogged
		ifFalse: [ ^ self ].
	self renderAccountButtonOn: html
]

{ #category : #rendering }
ASDBPORHeaderPharoIde >> renderContentOn: html [
	html mdlLayoutHeader
		with: [ "self renderDrawerOn: html"
			html
				mdlLayoutHeaderRow: [ html mdlNavigationLink
						callback: [ "Just refresh" ];
						with: [ html mdlLayoutTitle: [ html text: 'Pharo Online IDE' ] ].
					self renderNavMenu: html.
					html mdlLayoutSpacer.
					self renderButtonsOn: html ].
			 ]
]

{ #category : #rendering }
ASDBPORHeaderPharoIde >> renderDrawerOn: html [
	html
		mdlLayoutDrawer: [ html
				mdlNavigation: [ self possiblePages
						do: [ :aClass | 
							html mdlNavigationLink
								beCurrentIf: aClass = self rootComponent componentToDisplay class;
								callback: [ self displayInstanceOf: aClass ];
								with: aClass pageName ] ] ]
]

{ #category : #rendering }
ASDBPORHeaderPharoIde >> renderNavMenu: html [

	html mdlNavigation: [ 
			html mdlNavigationLink
				"onClick:
					(html jQuery id: self rootComponent idDialog , 'Playground')
						dialog open;"
				with: 'Playground'
			]
]

{ #category : #rendering }
ASDBPORHeaderPharoIde >> renderTabBarOn: html [

	html mdlLayoutTabBar: [ 
		self possiblePages do: [ :aClass | 
			html mdlLayoutTab
				callback: [ self displayInstanceOf: aClass ];
				isActiveIf: aClass = self rootComponent componentToDisplay class;
				with: aClass pageName ] ]
]
