#!/usr/bin/perl
# Copyright (C) 2014 Tony Crisci <tony@dubstepdish.com>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Requires playerctl binary to be in your path (except cmus)
# See: https://github.com/acrisci/playerctl

# Set instance=NAME in the i3blocks configuration to specify a music player
# (playerctl will attempt to connect to org.mpris.MediaPlayer2.[NAME] on your
# DBus session).

my @metadata = ();

# try cmus first
my @cmus = split /^/, qx(cmus-remote -Q);
if ($? == 0) {
    foreach my $line (@cmus) {
        my @data = split /\s/, $line;
        if (shift @data eq 'tag') {
            my $key = shift @data;
            my $value = join ' ', @data;

            @metadata[0] = $value if $key eq 'artist';
            @metadata[1] = $value if $key eq 'title';
        }
    }

    if (@metadata) {
        # metadata found so we are done
        print(join ' - ', @metadata);
        exit 0;
    }
}

my $artist = `playerctl metadata artist 2>&1`;
# exit status will be nonzero when playerctl cannot find your player
exit(1) if $?;
exit(1) if $artist =~ /^(.*)(Connection to player failed)(.*)$/;
exit(0) if $artist eq '(null)';
push(@metadata, $artist) if $artist;

my $title = `playerctl metadata title 2>&1`;
exit(1) if $?;
push(@metadata, $title) if $title;

print(join(" - ", @metadata)) if @metadata;

