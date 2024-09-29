-- WirePlumber
--
-- Copyright © 2023 Collabora Ltd.
--    @author Ashok Sidipotu <ashok.sidipotu@collabora.com>
--
-- SPDX-License-Identifier: MIT

cutils = require ("common-utils")
mutils = require ("monitor-utils")

log = Log.open_topic ("s-monitors-v4l2")

config = {}
config.rules = Conf.get_section_as_json ("monitor.v4l2.rules", Json.Array {})

SimpleEventHook {
  name = "monitor/v4l2/create-node",
  after = "monitor/v4l2/name-node",
  interests = {
    EventInterest {
      Constraint { "event.type", "=", "create-v4l2-device-node" },
    },
  },
  execute = function(event)
    local properties = event:get_data ("node-properties")
    local parent = event:get_subject ()
    local id = event:get_data ("node-sub-id")
    local factory = event:get_data ("factory")

    -- apply properties from rules defined in JSON .conf file
    properties = JsonUtils.match_rules_update_properties (config.rules, properties)

    if cutils.parseBool (properties ["node.disabled"]) then
      log:notice ("V4L2 node" .. properties ["node.name"] .. " disabled")
      return
    end
    -- create the node
    local node = Node ("spa-node-factory", properties)
    node:activate (Feature.Proxy.BOUND)
    parent:store_managed_object (id, node)
  end
}:register ()
