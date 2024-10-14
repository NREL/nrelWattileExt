#! /usr/bin/env fan

// Copyright (C) 2024, Alliance for Sustainable Energy, LLC
// All Rights Reserved

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
    version = Version("0.3.0")
    meta    = [
                "ext.name":        "nrelWattile",
                "ext.icon":        "target",
                "ext.depends":     "docker,py,task,nrelUtility",
                "org.name":        "NREL",
                "org.uri":         "https://www.nrel.gov/",
                "proj.name":       "NREL Wattile Extension",
                "proj.uri":        "https://github.com/NREL/nrelWattileExt/",
                "license.name":    "BSD-3",
              ]
    depends = ["sys 1.0+"]
    resDirs = [`lib/`, `locale/`]
    index   = ["skyarc.ext": "nrelWattileExt"]
  }
  
  // To publish to StackHub, use: bin/fan /path/to/build.fan publish 
  // For more information, see: https://skyfoundry.com/doc/stackhub/index#publishing
  
  //@Target { help = "Publish to stackhub.org " }
  Void publish() { stackhub::PublishTask(this).run }
}
