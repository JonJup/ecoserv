### --- Ecoserv 
### --- Downstream colonization with CDMetaPOP
### --- 19.11.20 
### --- Call script: get point from goal stream segment 

goal_segment = dt_rivers[ecoserv_id == ch_goal_segment_id]
goal_segment %<>% st_as_sf()
nxt_to_goal_segment = dt_rivers[TO == goal_segment$FROM] %>% st_as_sf()
goal_points = st_cast(goal_segment, to = "POINT")
nxt_to_goal_points = st_cast(nxt_to_goal_segment, to = "POINT")
right_point_id = which(goal_points$geom %in% nxt_to_goal_points$geom)
goal_point = goal_points[right_point_id,]
rm(goal_segment,nxt_to_goal_segment,goal_points,right_point_id,nxt_to_goal_points)
