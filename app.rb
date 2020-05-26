require 'aws-sdk'

hosted_zone_id = "fake"
Aws.config.update({
  region: 'ap-northeast-1',
})

r53 = Aws::Route53::Client.new
r53.list_hosted_zones[:hosted_zones].each do |zone|
  hosted_zone_id = zone[:id] if zone[:name] == "lab.takutakahashi.dev."
end

resp = r53.change_resource_record_sets({
  change_batch: {
    changes: [
      {
        action: "UPSERT", 
        resource_record_set: {
          name: "test.lab.takutakahashi.dev", 
          type: "A", 
          ttl: 300,
          resource_records: [
            {value: "10.10.0.1"},
          ],
        }, 
      }, 
    ], 
    comment: "test for lab", 
  }, 
  hosted_zone_id: hosted_zone_id,
})

puts resp
