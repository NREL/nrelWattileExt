#! /usr/bin/env fan

// Developed by the National Renewable Energy Laboratory
// NREL internal use only (at this time)

using build

**
** Build: nrelWattileExt
**

class Build : BuildPod
{
  new make()
  {
    podName = "nrelWattileExt"
    summary = "Interface extension for the Wattile Python package"
    version = Version("0.1")
    meta    = [
                "ext.name":        "nrelWattile",
                "ext.icon":        "target",
                "ext.depends":     "docker,py",
                "org.name":        "NREL",
                "org.uri":         "https://www.nrel.gov/",
                "proj.name":       "NREL Wattile Extension",
                "proj.uri":        "https://github.com/NREL/intelligentcampus-model-deploy", // TO DO: Update
                "license.name":    "Commercial", // TO DO: Update
              ]
    depends = ["sys 1.0"]
    resDirs = [`lib/`, `locale/`]
    index   = ["skyarc.ext": "nrelWattileExt"]
  }
  
  // FUTURE USE: Stackhub Publishing
  
  // To publish to StackHub, use: bin/fan /path/to/build.fan publish 
  // For more information, see: https://skyfoundry.com/doc/stackhub/index#publishing
  
  //@Target { help = "Publish to stackhub.org " }
  //Void publish() { stackhub::PublishTask(this).run }
}
