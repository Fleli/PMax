
import Foundation
import ArgumentParser

struct Logo: ParsableCommand {
    
    func run() throws {
        
        let str = """
        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@           @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        @@@@@@@@@@@@@@@@@@@@@@@@@@@       (((((((((((((       @@@@@@@@@@@@@@@@@@@@@@@@@@
        @@@@@@@@@@@@@@@@@@@@@@@    (((((((((((((((((((((((((((    @@@@@@@@@@@@@@@@@@@@@@
        @@@@@@@@@@@@@@@@@@@@   (((((((((((((((((((((((((((((((((((   @@@@@@@@@@@@@@@@@@@
        @@@@@@@@@@@@@@@@@   .((((((((((((((((((((((((((((((((((((       @@@@@@@@@@@@@@@@
        @@@@@@@@@@@@@@@   ((((((((((((((((((((((((((((((((((((((          @@@@@@@@@@@@@@
        @@@@@@@@@@@@@@  (((((((((((((((((((((((((((((((((((((((         .  @@@@@@@@@@@@@
        @@@@@@@@@@@@   (((((((((((((((((((((((((((((((((((((((           #  @@@@@@@@@@@@
        @@@@@@@@@@@@  ((((((((((((((((((((((((((((((((((((((             ##   @@@@@@@@@@
        @@@@@@@@@@@  ((((((((((((((((((((((((((((((((((((((              ###  @@@@@@@@@@
        @@@@@@@@@@  (((((((((((((((((((((((((((((((((((((                ####  @@@@@@@@@
        @@@@@@@@@@  (((((((((((((((((((((((((((((((((((                 #####  @@@@@@@@@
        @@@@@@@@@@  (((((((((((((((((((((((((((((((((                  ######  @@@@@@@@@
        @@@@@@@@@@  (((((((((((((((((((((((((((((((                   #######  @@@@@@@@@
        @@@@@@@@@@  ((((((((((((((((((((((((((((                    #########  @@@@@@@@@
        @@@@@@@@@@   ((((((((((((((((((((((((                    ###########   @@@@@@@@@
        @@@@@@@@@@@   ((((((((((((((((((((                  ###############(  @@@@@@@@@@
        @@@@@@@@@@@@  .(((((((((((((((               ######################  @@@@@@@@@@@
        @@@@@@@@@@@@@   (((((((((         ###############################   @@@@@@@@@@@@
        @@@@@@@@@@@@@@@  (      ########################################  @@@@@@@@@@@@@@
        @@@@@@@@@@@@@@@@   ###########################################   @@@@@@@@@@@@@@@
        @@@@@@@@@@@@@@@@@@@   #####################################   @@@@@@@@@@@@@@@@@@
        @@@@@@@@@@@@@@@@@@@@@    ###############################    @@@@@@@@@@@@@@@@@@@@
        @@@@@@@@@@@@@@@@@@@@@@@@@     (####################     @@@@@@@@@@@@@@@@@@@@@@@@
        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        """
        
        print(str)
        
    }
    
}
