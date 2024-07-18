"""Custom topology example

This is the Figure 1 Motivating Example in the paper:

           Switch_C-------------------Switch_B
            |                             |
   Host_1 --- Switch_A --- Switch_D --- Switch_E-----Host_2

Adding the 'topos' dict with a key/value pair to generate our newly defined
topology enables one to pass in '--topo=mytopo' from the command line.
"""

from mininet.topo import Topo

class MyTopo( Topo ):
    "Simple topology example."

    def build( self ):
        "Create custom topo."

        # Add hosts and switches
        aHost = self.addHost( 'h1', ip='10.0.0.1/24')
        bHost = self.addHost( 'h2', ip='10.0.0.2/24')

        aSwitch = self.addSwitch( 's1' )
        bSwitch = self.addSwitch( 's2' )
        cSwitch = self.addSwitch( 's3' )
        dSwitch = self.addSwitch( 's4' )
        eSwitch = self.addSwitch( 's5' )

        # Add links
        self.addLink( aSwitch, dSwitch )
        self.addLink( aSwitch, cSwitch )
        self.addLink( bSwitch, cSwitch )
        self.addLink( bSwitch, eSwitch )
        self.addLink( dSwitch, eSwitch )
        self.addLink( aHost, aSwitch )
        self.addLink( bHost, eSwitch )

topos = { 'mytopo': ( lambda: MyTopo() ) }
