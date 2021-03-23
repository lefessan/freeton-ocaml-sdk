(**************************************************************************)
(*                                                                        *)
(*  Copyright (c) 2021 Origin Labs & OCamlPro SAS                         *)
(*                                                                        *)
(*  All rights reserved.                                                  *)
(*  This file is distributed under the terms of the GNU Lesser General    *)
(*  Public License version 2.1, with the special exception on linking     *)
(*  described in the LICENSE.md file in the root directory.               *)
(*                                                                        *)
(*                                                                        *)
(**************************************************************************)

open Json_encoding

type info_in = {
  ton_version : string;
  ton_time : int64 [@encoding Json_encoding.int53];
} [@@deriving json_encoding]

type info = info_in [@obj1 "info"] [@@deriving json_encoding]

let z_enc = conv Z.to_string Z.of_string string
type z = Z.t [@encoding z_enc] [@@deriving json_encoding]

(* AccountStatusEnum can be:
   0 => Uninit
   1 => Active
*)



type account = {
  acc_id : string;
  acc_type : int; [@key "acc_type"]
  acc_type_name: string option ; (* AccountStatusEnum *) [@key "acc_type_name"]
  acc_balance : z option;
  (*  balance_other: [OtherCurrency] *)
  (* bits(...): String *)
  acc_boc : string option ;
  (* cells(...): String *)
  acc_code : string option ;
  acc_code_hash : string option ;
  acc_data: string option ;
  acc_data_hash: string option ;
  (*  due_payment(format: BigIntFormat): String *)
  acc_last_paid: float option ;
  (* last_trans_lt(format: BigIntFormat): String *)
  acc_library: string option ;
  acc_library_hash: string option ;
  acc_proof: string option ;
  (* public_cells(...): String *)
  acc_split_depth: int option ;
  acc_state_hash: string option ;
  acc_tick: bool option ;
  acc_tock: bool option ;
  acc_workchain_id: int option ;
} [@@deriving json_encoding]

type accounts = account list [@obj1 "accounts"] [@@deriving json_encoding]

type ext_blk_ref = {
  ebr_end_lt : string;
  ebr_seq_no : int;
  ebr_root_hash : string;
  ebr_file_hash : string;
} [@@deriving json_encoding]

type block_value_flow = {
  bl_volume : z; [@key "to_next_blk"]
  bl_fees : z; [@key "fees_collected"]
  bl_minted : z;
} [@@deriving json_encoding]



type out_message = {
  out_import_block_lt : string option ;
  (* imported: InMsg *)
  out_msg_env_hash: string option ;
  out_msg_id: string option ;
  out_msg_type: int option ;
  out_msg_type_name: string option ;
  out_next_addr_pfx : string option ;
  out_next_workchain: int option ;
  (* out_msg: MsgEnvelope *)
  (* reimport: InMsg *)
  out_transaction_id: string option ;
} [@@deriving json_encoding]

type in_message = {
  in_fwd_fee : string option ;
  in_ihr_fee : string option ;
  (*  in_msg: MsgEnvelope *)
  in_msg_id: string option ;
  in_msg_type: int option ;
  in_msg_type_name: string option ;
  (* out_msg: MsgEnvelope *)
  in_proof_created: string option ;
  in_proof_delivered: string option ;
  in_transaction_id: string option ;
  in_transit_fee: string option ;
} [@@deriving json_encoding]

type block = {
  bl_id : string;

(*
account_blocks: [BlockAccountBlocks]
after_merge: Boolean
after_split: Boolean
before_split: Boolean
boc: String
*)
  bl_created_by: string ;   (* collator *)

    (*
end_lt(...): String
flags: Int
gen_catchain_seqno: Float
gen_software_capabilities: String
gen_software_version: Float
*)
  bl_time : int64; [@key "gen_utime"] [@encoding int53]  (* gen_utime: Float *)
  (*
gen_utime_string: String
gen_validator_list_hash_short: Float
global_id: Int
*)
  bl_in_msg_descr: in_message list ;

  bl_key_block : bool;
(*
master: BlockMaster
master_ref: ExtBlkRef
min_ref_mc_seqno: Float
*)
  bl_out_msg_descr: out_message list ;
                 (*
prev_alt_ref: ExtBlkRef
prev_key_block_seqno: Float
*)
    bl_prev_ref : ext_blk_ref;
(*
prev_vert_alt_ref: ExtBlkRef
prev_vert_ref: ExtBlkRef
rand_seed: String
*)
  bl_shard : string;
  bl_seq_no : int;
  (*
signatures(...): BlockSignatures
start_lt(...): String
state_update: BlockStateUpdate
*)
  bl_status : int;
  bl_status_name : string option;
  bl_tr_count : int;
  bl_value_flow : block_value_flow;

(*
version: Float
vert_seq_no: Float
want_merge: Boolean
want_split: Boolean
*)
  bl_workchain_id : int;

} [@@deriving json_encoding]





type blocks = block list [@obj1 "blocks"] [@@deriving json_encoding]


type transaction_summary = {
  trs_id : string; [@key "id"]
} [@@deriving json_encoding]


type message = {
  msg_id : string;
  (* block(...): Block *)
  msg_block_id : string option;
  msg_boc : string option;
  msg_body : string option;
  msg_body_hash : string option;
  msg_bounce : bool option ;
  msg_bounced : bool option ;
  msg_code : string option ;
  msg_code_hash : string option ;
  msg_created_at : string option ;
  msg_created_at_string : string option ;
  msg_created_lt : string option ;
  msg_data : string option ;
  msg_data_hash : string option ;
  msg_dst : string;
  msg_dst_transaction : transaction_summary option ;
  (* dst_transaction(...): Transaction *)
  msg_dst_workchain_id: int option ;
  msg_fwd_fee: string option ;
  msg_ihr_disabled: bool option ;
  msg_ihr_fee : string option ;
  msg_import_fee : string option ;
  msg_library: string option ;
  msg_library_hash: string option ;
  msg_type : int; [@key "msg_type"]
  msg_msg_type_name: string option ;
  msg_proof: string option ;
  msg_split_depth: int option ;
  msg_src : string;
  msg_src_transaction : transaction_summary option ;
  (* src_transaction(...): Transaction *)
  msg_src_workchain_id: int option ;
  msg_status : int;
  msg_status_name: string option ;
  msg_tick: bool option;
  msg_tock: bool option;
  msg_value : z option;
  (* value_other: [OtherCurrency] *)
} [@@deriving json_encoding {option="option"}]





type messages = message list [@obj1 "messages"] [@@deriving json_encoding]






type transaction = {
  tr_id : string;
  tr_aborted: bool;
  tr_account_addr : string;
   (*
action: TransactionAction
*)
    tr_balance_delta : z;
    (*
balance_delta_other: [OtherCurrency]
block(...): Block
*)
    tr_block_id : string;
    tr_boc : string option ;
(*
bounce: TransactionBounce
compute: TransactionCompute
credit: TransactionCredit
credit_first: Boolean
*)
    tr_destroyed: bool option ;
    tr_end_status: int option ;
    tr_end_status_name : string option ;
    (*
in_message(...): Message //  tr_in_message : message option;
*)
  tr_in_msg: string ;
  tr_installed: bool option ;
  tr_lt: string option ; (* logical_time *)
  tr_new_hash: string option ;
  tr_now: float option ;
  tr_old_hash: string option ;
  tr_orig_status: int option ;
  tr_orig_status_name: string option ;
  (*
out_messages(...): [Message]
*)
  tr_out_msgs: string list ;
  tr_outmsg_cnt: int option ;
  tr_prepare_transaction: string option ;
  tr_prev_trans_hash: string option ;
  tr_prev_trans_lt: string option ;
  tr_proof: string option ;
(*
split_info: TransactionSplitInfo
*)
  tr_status : int;
  tr_status_name : string option ;
(*
storage: TransactionStorage
*)
    tr_total_fees : z;
    (*
        total_fees_other: [OtherCurrency]
                          *)
  tr_tr_type : int; [@key "tr_type"]
  tr_tr_type_name: string option ;
  tr_tt : string option ;
  tr_workchain_id: int option ;
  } [@@deriving json_encoding {option="option"}]







type transactions = transaction list [@obj1 "transactions"] [@@deriving json_encoding]

let string_of_transaction tr =
  EzEncoding.construct ~compact:false transaction_enc tr

let string_of_account tr =
  EzEncoding.construct ~compact:false account_enc tr

let string_of_message tr =
  EzEncoding.construct ~compact:false message_enc tr

let string_of_block tr =
  EzEncoding.construct ~compact:false block_enc tr
