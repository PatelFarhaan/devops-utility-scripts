# <==================================================================================================>
#                                           IMPORTS
# <==================================================================================================>
import boto3


# <==================================================================================================>
#                                          AWS CLIENT
# <==================================================================================================>
client = boto3.client("autoscaling",
                      region_name="us-east-1",
                      aws_access_key_id="",
                      aws_secret_access_key=""
                      )


# <==================================================================================================>
#                                          FETCH EB DETAILS
# <==================================================================================================>
def get_eb_details(eb_name):
    auto_scaling_details = client.describe_auto_scaling_groups()

    if not isinstance(auto_scaling_details, dict):
        return {"result": False, "message": "response is not a json", "data": None}

    if "AutoScalingGroups" not in auto_scaling_details.keys():
        return {"result": False, "message": "autoscaling not present in keys", "data": None}

    for eb_obj in auto_scaling_details["AutoScalingGroups"]:
        if eb_obj.get("AutoScalingGroupName") == eb_name:
            return {"result": True, "message": "record found", "data": eb_obj}
    return {"result": True, "message": "no record found", "data": None}


# <==================================================================================================>
#                                     CHEK DESIRED COUNT > MAX COUNT
# <==================================================================================================>
def check_desired_is_not_greater_than_max(eb_obj, instances_to_add):
    desired_count = eb_obj.get("DesiredCapacity") + instances_to_add
    max_count = eb_obj.get("MaxSize")

    if desired_count > max_count:
        print("Desired Capacity is greater than Max Count")
        return True

    print("Desired Capacity is not greater than Max Count")
    return False


# <==================================================================================================>
#                                         INCREASE MAX SIZE
# <==================================================================================================>
def increase_max_size(eb_obj, desired_size):
    print("Increasing the max count size of Auto Scaling Group")
    request_obj = {
        "AutoScalingGroupName": eb_obj.get("AutoScalingGroupName"),
        "MaxSize": desired_size
    }
    response = client.update_auto_scaling_group(**request_obj)
    print(response)


# <==================================================================================================>
#                                         INCREASE DESIRED SIZE
# <==================================================================================================>
def increase_desired_size(eb_obj, desired_size):
    print("Increasing the desired count size for Auto Scaling Group")
    request_obj = {
        "AutoScalingGroupName": eb_obj.get("AutoScalingGroupName"),
        "DesiredCapacity": desired_size
    }
    response = client.update_auto_scaling_group(**request_obj)
    print(response)


# <==================================================================================================>
#                                         MAIN FUNCTION
# <==================================================================================================>
if __name__ == "__main__":
    name = "awseb-e-n92t5fnpbx-stack-AWSEBAutoScalingGroup-1OLB4BDDXD8TX"
    no_of_instances_to_add = 1
    print("Auto Scaling Group Name:", name)
    print("Number of Instances to increase:", no_of_instances_to_add)
    print("Starting Auto Scaling...")
    resp = get_eb_details(name)
    if resp.get("result"):
        eb_obj = resp.get("data")
        desired_size = data.get("DesiredCapacity") + no_of_instances_to_add

        print("Checking if desired value is greater than max count")
        if check_desired_is_not_greater_than_max(eb_obj, instances_to_add):
            increase_max_size(eb_obj, desired_size)
        increase_desired_size(eb_obj, desired_size)
    print("Auto Scaling completed!")

# Considerations:
# Desired count cannot be greater than max, if it is then we need to make max = desired count
