#!/usr/bin/env coffee --literate

	require 'atoz'

	net = '/usr/sbin/networksetup'
	network = execSync "#{net} -getairportnetwork"

	network.print()
