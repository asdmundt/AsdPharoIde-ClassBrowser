Class {
	#name : #ASDBPORHeaderClassBrowser,
	#superclass : #ASDBPORHeader,
	#category : #'AsdPharoIde-ClassBrowser-Component'
}

{ #category : #rendering }
ASDBPORHeaderClassBrowser >> renderAccountButtonOn: html [
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
ASDBPORHeaderClassBrowser >> renderAddButtonOn: html [
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
ASDBPORHeaderClassBrowser >> renderButtonsOn: html [
	self session isLogged
		ifFalse: [ ^ self ].
	self renderAccountButtonOn: html
]

{ #category : #rendering }
ASDBPORHeaderClassBrowser >> renderContentOn: html [

	html mdlLayoutHeader with: [ "self renderDrawerOn: html"
			html mdlLayoutHeaderRow: [ 
					html mdlNavigationLink
						callback: [ self rootComponent goToOverviewView ];
						with: [ html mdlLayoutTitle: [ html text: 'Pharo Online IDE' ] ].
					self renderNavMenu: html.
					html mdlLayoutSpacer.
					self renderButtonsOn: html
					]
			]
]

{ #category : #rendering }
ASDBPORHeaderClassBrowser >> renderDrawerOn: html [
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
ASDBPORHeaderClassBrowser >> renderNavMenu: html [

	html mdlNavigation: [ 
			html mdlButton icon
				id: #bottomLeftButton;
				with: [ html mdlIcon: #account_circle ];
				onClick:
					(html jQuery id: self rootComponent idPlayGrount)
						dialog open
			]
]

{ #category : #rendering }
ASDBPORHeaderClassBrowser >> renderTabBarOn: html [

	html mdlLayoutTabBar: [ 
		self possiblePages do: [ :aClass | 
			html mdlLayoutTab
				callback: [ self displayInstanceOf: aClass ];
				isActiveIf: aClass = self rootComponent componentToDisplay class;
				with: aClass pageName ] ]
]
