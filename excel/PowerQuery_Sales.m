// ============================================================
//  Excel  <-  Supabase   (one-way, read-only sales feed)
//
//  !!  REPLACE the two values below with YOUR OWN Supabase
//      Project URL + anon key  (Supabase -> Settings -> API).
//      They are unique to your project -- someone else's won't
//      work. (When Claude builds your folder, it fills these
//      in for you automatically.)
//
//  1. Excel: Data > Get Data > From Other Sources > Blank Query
//  2. Home > Advanced Editor > delete all > paste this > Done
//  3. Close & Load
//  4. First refresh: choose ANONYMOUS when asked how to connect
//     (auth is the apikey header, not an Excel login)
//  5. Refresh anytime with Data > Refresh All
//
//  The anon key is READ-ONLY here -- RLS blocks any write. OK
// ============================================================
let
    ProjectUrl = "https://vaqoxdjfegzgqbdyihsh.supabase.co",
    AnonKey    = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZhcW94ZGpmZWd6Z3FiZHlpaHNoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODkyNzAwMTAsImV4cCI6MjEwNDg0NjAxMH0.SHpSMBxbhMgab_SmZbDuk0XM4-JuiSVxRtKfhs2gQ3o",

    Response = Web.Contents(ProjectUrl & "/rest/v1/posinv_sales_report", [
        Query   = [ #"select" = "*", #"order" = "order_on.desc" ],
        Headers = [ apikey = AnonKey, Authorization = "Bearer " & AnonKey ]
    ]),

    Json  = Json.Document(Response),
    Table = Table.FromRecords(Json),

    // Type the columns so pivots/reports behave.
    Typed = Table.TransformColumnTypes(Table, {
        {"order_id",     Int64.Type},
        {"order_on",     type datetimezone},
        {"status",       type text},
        {"customer",     type text},
        {"cashier",      type text},
        {"sku",          type text},
        {"product_name", type text},
        {"qty",          type number},
        {"unit_price",   type number},
        {"disc_pct",     type number},
        {"line_total",   type number},
        {"order_total",  type number}
    })
in
    Typed
