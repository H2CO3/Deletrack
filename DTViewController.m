//
// DTViewController.m
// Deletrack
//
// Copyright H2CO3, 2011.
// Created by Árpád Goretity, 04/10/2011.
//
// Licensed under a CreativeCommons Attribution 3.0 Unported License
//

#import "DTViewController.h"

#define CELL_ID @"DTCell"
#define DTDonateShownKey @"DTDonateShown"


@implementation DTViewController

- (id) init {
	self = [super initWithStyle:UITableViewStylePlain];
	self.title = @"Delete songs";
	self.tabBarItem = [[[UITabBarItem alloc] initWithTitle:self.title image:[UIImage imageNamed:@"BarSongs.png"] tag:9999 ] autorelease];
	if ([[NSUserDefaults standardUserDefaults] boolForKey:DTDonateShownKey] == NO) {
		UIAlertView *av = [[UIAlertView alloc] init];
		av.title = @"Please donate";
		av.message = @"Lots of hard work went to the development of this tweak. If you like it, I'd greatly appreciate donations in order to buy 	myself a new iPhone which could help me continuing development. Thank you very much!";
		av.delegate = self;
		[av addButtonWithTitle:@"Donate"];
		[av addButtonWithTitle:@"Later"];
		[av show];
		[av release];
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:DTDonateShownKey];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	return self;
}

// UIAlertViewDelegate

- (void) alertView:(UIAlertView *)av didDismissWithButtonIndex:(int)index {
	if (index == 0) {
		// User hit Donate!
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://apaczai.elte.hu/~13akga/donate/index.html"]];
	}
}

// UITableViewDelegate

- (void) tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tv deselectRowAtIndexPath: indexPath animated: YES];
}

- (void) tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)style forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (style == UITableViewCellEditingStyleDelete) {
		[[MFMusicLibrary sharedLibrary] removeTrackForIndex:indexPath.row];
		[[MFMusicLibrary sharedLibrary] write];
		[tv deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
	}
}

// UITableViewDataSource

- (int) tableView:(UITableView *)tv numberOfRowsInSection:(int)section {
	return [[MFMusicLibrary sharedLibrary] numberOfTracks];
}

- (UITableViewCell *) tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CELL_ID];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELL_ID] autorelease];
	}
	NSAutoreleasePool *p = [[NSAutoreleasePool alloc] init];
	MFMusicTrack *track = [[MFMusicLibrary sharedLibrary] trackForIndex:indexPath.row];
	cell.textLabel.text = track.title;
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", track.artist, track.album];
	[p release];
	return cell;
}

@end

