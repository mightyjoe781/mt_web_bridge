#!/bin/sh

root_dir=/var/lib/multicraft
conf_file=$root_dir/worlds/prismo/multicraft.conf
log_file=$root_dir/worlds/prismo/current.txt
world_dir=$root_dir/worlds/prismo

/usr/local/bin/multicraftserver --world $world_dir \
    --port 30000 \
    --config $conf_file \
    --logfile $log_file \
    --gameid minetest
    