(* virt-sysprep
 * Copyright (C) 2013 Fujitsu Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 *)

open Common_utils
open Sysprep_operation
open Common_gettext.Gettext

module G = Guestfs

let paths = ref []
let add_paths path = paths := path :: !paths

let path_perform g root =
  let paths = List.rev !paths in
  List.iter g#rm_rf paths;
  []

let op = {
  defaults with
    name = "delete";
    enabled_by_default = true;
    heading = s_"Delete specified files or directories";
    pod_description = Some (s_"\
Delete specified files or directories.

Use the I<--delete> option to specify a path to remove.");
    extra_args = [
      ("--delete", Arg.String add_paths, s_"path" ^ " " ^ s_"File or directory to be removed on guest"),
      s_"\
Delete (recursively) the specified C<path> on guest.";
    ];

    perform_on_filesystems = Some path_perform;
}

let () = register_operation op
