#import "FMDatabase+FMDBHelpers.h"
#import "FMResultSet+FMDBHelpers.h"
#import "FMDB.h"

@implementation FMDatabase (FMDBHelpers)

// ========== INITIALIZATION ===========================================================================================
#pragma mark - Initialization

+ (instancetype)temporaryDatabase
{
  return [self databaseWithPath:@""];
}

+ (instancetype)inMemoryDatabase
{
  return [self databaseWithPath:nil];
}

// ========== OPEN =====================================================================================================
#pragma mark - Open

- (BOOL)open:(NSError **)error_p
{
  BOOL opened = [self open];
  if (NO == opened && error_p != NULL)
  {
    *error_p = self.lastError;
  }
  return opened;
}

- (BOOL)openWithFlags:(int)flags
                error:(NSError **)error_p
{
  BOOL opened = [self openWithFlags:flags];
  if (NO == opened && error_p != NULL)
  {
    *error_p = self.lastError;
  }
  return opened;
}

// ========== ESCAPE ===================================================================================================
#pragma mark - Escape

+ (NSString *)escapeString:(NSString *)value
{
  value = [value stringByReplacingOccurrencesOfString:@"'"
                                           withString:@"''"];
  
  return [NSString stringWithFormat:@"'%@'", value];
}

+ (NSString *)escapeIdentifier:(NSString *)value
{
  value = [value stringByReplacingOccurrencesOfString:@"\""
                                           withString:@"\"\""];
  
  return [NSString stringWithFormat:@"\"%@\"", value];
  
}

+ (NSString *)escapeValue:(id)value
{
  if (value == nil || value == [NSNull null])
  {
    return @"NULL";
  }
  else if ([value isKindOfClass:[NSString class]])
  {
    return [self escapeString:value];
  }
  else if ([value respondsToSelector:@selector(stringValue)])
  {
    return [self escapeString:[value stringValue]];
  }
  else
  {
    return [self escapeString:[value description]];
  }
}

+ (NSString *)listOfColumns:(NSArray *)columnNames
{
  if (columnNames != nil)
  {
    return [columnNames componentsJoinedByString:@","];
  }
  else
  {
    return @"*";
  }
}

// ========== UPDATES ==================================================================================================
#pragma mark - Updates

- (BOOL)executeUpdate:(NSString *)sql
                error:(NSError **)error_p
{
  return [self executeUpdate:sql
        withArgumentsInArray:@[]
                       error:error_p];
}

- (BOOL)executeUpdate:(NSString *)sql
 withArgumentsInArray:(NSArray *)arguments
                error:(NSError **)error_p
{
#if DEBUG
  if (getenv("DEBUG_SQL"))
  {
    NSLog(@"executeUpdate: %@\n%@", sql, arguments);
  }
#endif
  
  BOOL successful = [self executeUpdate:sql
                   withArgumentsInArray:arguments];
  if (NO == successful && error_p != NULL)
  {
    *error_p = self.lastError;
  }
  return successful;
}

- (BOOL)  executeUpdate:(NSString *)sql
withParameterDictionary:(NSDictionary *)arguments
                  error:(NSError **)error_p
{
#if DEBUG
  if (getenv("DEBUG_SQL"))
  {
    NSLog(@"executeUpdate: %@\n%@", sql, arguments);
  }
#endif
  
  BOOL successful = [self executeUpdate:sql
                withParameterDictionary:arguments];
  if (NO == successful && error_p != NULL)
  {
    *error_p = self.lastError;
  }
  return successful;
}

// ========== SCHEMA ===================================================================================================
#pragma mark - Schema

- (NSDictionary *)databaseSchema
{
  NSMutableDictionary * tableSchemas = [[NSMutableDictionary alloc] init];
  for (NSString * tableName in self.tableNames)
  {
    NSDictionary * tableSchema = [self tableSchema:tableName];
    if (tableSchema != nil)
    {
      tableSchemas[tableName] = tableSchema;
    }
  }
  
  return tableSchemas;
}

- (NSDictionary *)tableSchema:(NSString *)tableName
{
  NSMutableDictionary * tableSchema = [[NSMutableDictionary alloc] init];
  FMResultSet * resultSet = [self getTableSchema:tableName];
  while ([resultSet next])
  {
    NSMutableDictionary * columnInfo = [[NSMutableDictionary alloc] init];
    for (int columnIndex = 0; columnIndex < [resultSet columnCount]; columnIndex++)
    {
      NSString * name = [resultSet columnNameForIndex:columnIndex];
      columnInfo[name] = resultSet[columnIndex];
    }
    tableSchema[columnInfo[@"name"]] = columnInfo;
  }
  
  return tableSchema;
}

- (NSSet *)tableNames
{
  FMResultSet * schema = [self getSchema];
  NSMutableSet * tableNames = [[NSMutableSet alloc] init];
  while ([schema next])
  {
    NSString * type = [schema stringForColumn:@"type"];
    if ([type isEqualToString:@"table"])
    {
      [tableNames addObject:[schema stringForColumn:@"name"]];
    }
  }
  return tableNames;
}


- (NSSet *)indexNamesOnTable:(NSString *)tableName
{
  FMResultSet * schema = [self getSchema];
  NSMutableSet * indexNames = [[NSMutableSet alloc] init];
  while ([schema next])
  {
    NSString * type = [schema stringForColumn:@"type"];
    NSString * indexTableName = [schema stringForColumn:@"tbl_name"];
    if ([type isEqualToString:@"index"]
        && [indexTableName isEqualToString:tableName])
    {
      [indexNames addObject:[schema stringForColumn:@"name"]];
    }
  }
  return indexNames;
}

// ========== TABLES ===================================================================================================
#pragma mark - Tables

- (BOOL)createTableWithName:(NSString *)tableName
                    columns:(NSArray *)columns
                constraints:(NSArray *)constraints
                      error:(NSError **)error_p
{
  NSMutableArray * createTable = [[NSMutableArray alloc] init];
  
  [createTable addObject:@"CREATE TABLE IF NOT EXISTS"];
  
  [createTable addObject:[FMDatabase escapeIdentifier:tableName]];
  [createTable addObject:@"("];
  
  BOOL isFirstColumn = YES;
  for (id columnDef in columns)
  {
    if (isFirstColumn == NO)
    {
      [createTable addObject:@","];
    }
    
    if ([columnDef isKindOfClass:[NSArray class]])
    {
      for (NSString * component in columnDef)
      {
        [createTable addObject:component];
      }
    }
    else if ([columnDef isKindOfClass:[NSString class]])
    {
      [createTable addObject:columnDef];
    }
    else
    {
      @throw [NSException exceptionWithName:NSInvalidArgumentException
                                     reason:[NSString stringWithFormat:@"Invalid column definition (%@): %@",
                                             NSStringFromClass([columnDef class]),
                                             columnDef]
                                   userInfo:nil];
    }
    
    isFirstColumn = NO;
  }
  
  // constraints
  for (NSString * constraint in constraints)
  {
    [createTable addObject:@","];
    [createTable addObject:constraint];
  }

  [createTable addObject:@")"];
    
    NSLog(@"create table sql:\n%@",[createTable componentsJoinedByString:@" "]);
  
  return [self executeUpdate:[createTable componentsJoinedByString:@" "]
                       error:error_p];
}

- (BOOL)renameTable:(NSString *)tableName
                 to:(NSString *)newTableName
              error:(NSError **)error_p
{
  NSMutableArray * renameTable = [[NSMutableArray alloc] init];
  [renameTable addObject:@"ALTER TABLE"];
  [renameTable addObject:[FMDatabase escapeIdentifier:tableName]];
  [renameTable addObject:@"RENAME TO"];
  [renameTable addObject:[FMDatabase escapeIdentifier:newTableName]];
  
  return [self executeUpdate:[renameTable componentsJoinedByString:@" "]
                       error:error_p];
}

- (BOOL)addColumn:(NSString *)columnDefinition
          toTable:(NSString *)tableName
            error:(NSError **)error_p
{
  NSMutableArray * addColumn = [[NSMutableArray alloc] init];
  [addColumn addObject:@"ALTER TABLE"];
  [addColumn addObject:[FMDatabase escapeIdentifier:tableName]];
  [addColumn addObject:@"ADD COLUMN"];
  [addColumn addObject:columnDefinition];
  
  return [self executeUpdate:[addColumn componentsJoinedByString:@" "]
                       error:error_p];
}

- (BOOL)dropTableWithName:(NSString *)tableName
                    error:(NSError **)error_p
{
  return [self dropTableWithName:tableName
                        ifExists:NO
                           error:error_p];
}

- (BOOL)dropTableIfExistsWithName:(NSString *)tableName
                            error:(NSError **)error_p
{
  return [self dropTableWithName:tableName
                        ifExists:YES
                           error:error_p];
}

- (BOOL)dropTableWithName:(NSString *)tableName
                 ifExists:(BOOL)ifExists
                    error:(NSError **)error_p
{
  NSMutableArray * dropTable = [[NSMutableArray alloc] init];
  
  [dropTable addObject:@"DROP TABLE"];
  if (ifExists)
  {
    [dropTable addObject:@"IF EXISTS"];
  }
  
  [dropTable addObject:[FMDatabase escapeIdentifier:tableName]];

  return [self executeUpdate:[dropTable componentsJoinedByString:@" "]
                       error:error_p];
}

// ========== INDEXES ==================================================================================================
#pragma mark - Indexes

- (BOOL)createIndexWithName:(NSString *)indexName
                  tableName:(NSString *)tableName
                    columns:(NSArray *)columns
                      error:(NSError **)error_p
{
  return [self createIndexWithName:indexName
                         tableName:tableName
                           columns:columns
                            unique:NO
                             error:error_p];
}

- (BOOL)createUniqueIndexWithName:(NSString *)indexName
                        tableName:(NSString *)tableName
                          columns:(NSArray *)columns
                            error:(NSError **)error_p
{
  return [self createIndexWithName:indexName
                         tableName:tableName
                           columns:columns
                            unique:YES
                             error:error_p];
}

- (BOOL)createIndexWithName:(NSString *)indexName
                  tableName:(NSString *)tableName
                    columns:(NSArray *)columns
                     unique:(BOOL)isUnique
                      error:(NSError **)error_p
{
  NSMutableArray *createIndex = [NSMutableArray arrayWithObject:@"CREATE"];
  
  if (isUnique) [createIndex addObject:@"UNIQUE"];
  [createIndex addObject:@"INDEX"];
  [createIndex addObject:[FMDatabase escapeIdentifier:indexName]];
  [createIndex addObject:@"ON"];
  [createIndex addObject:[FMDatabase escapeIdentifier:tableName]];
  
  [createIndex addObject:@"("];
  [createIndex addObject:[columns componentsJoinedByString:@", "]]; 
  [createIndex addObject:@")"];
  
  return [self executeUpdate:[createIndex componentsJoinedByString:@" "]
                       error:error_p];
}


- (BOOL)dropIndexWithName:(NSString *)indexName
                    error:(NSError **)error_p
{
  NSMutableArray * dropIndex = [[NSMutableArray alloc] init];
  [dropIndex addObject:@"DROP INDEX"];
  [dropIndex addObject:[FMDatabase escapeIdentifier:indexName]];
  
  return [self executeUpdate:[dropIndex componentsJoinedByString:@" "]
                       error:error_p];
}

// ========== INSERT ===================================================================================================
#pragma mark - Insert

+ (NSString *)argumentTupleOfSize:(NSUInteger)tupleSize
{
  NSMutableArray * tupleString = [[NSMutableArray alloc] init];
  [tupleString addObject:@"("];
  for (NSUInteger columnIdx = 0; columnIdx < tupleSize; columnIdx++)
  {
    if (columnIdx > 0)
    {
      [tupleString addObject:@","];
    }
    [tupleString addObject:@"?"];
  }
  [tupleString addObject:@")"];
  
  return [tupleString componentsJoinedByString:@" "];
}

- (BOOL)insertInto:(NSString *)tableName
           columns:(NSArray *)columnNames
            values:(NSArray *)values
             error:(NSError **)error_p
{
  NSParameterAssert(columnNames != nil);
  NSParameterAssert(columnNames.count > 0);
  NSParameterAssert(tableName != nil);
  
  NSMutableArray * insertSQL = [[NSMutableArray alloc] init];
  
  [insertSQL addObject:@"INSERT INTO"];
  [insertSQL addObject:tableName];
  
  if (columnNames.count > 0) {
    [insertSQL addObject:@"("];
    
    [columnNames enumerateObjectsUsingBlock:^(NSString * columnName, NSUInteger idx, BOOL *stop) {
      if (idx > 0)
      {
        [insertSQL addObject:@","];
      }
      
      [insertSQL addObject:[FMDatabase escapeIdentifier:columnName]];
    }];
    
    [insertSQL addObject:@")"];
  }
  
  NSMutableArray * flattenedValues = [[NSMutableArray alloc] initWithCapacity:(columnNames.count * values.count)];
  if (values.count == 0)
  {
    [insertSQL addObject:@"DEFAULT VALUES"];
  }
  else
  {
    [insertSQL addObject:@"VALUES"];
    
    NSString * argumentTuple = [FMDatabase argumentTupleOfSize:columnNames.count];
    
    [values enumerateObjectsUsingBlock:^(NSArray * row, NSUInteger rowIdx, BOOL *stop) {
      
      NSParameterAssert(row.count == columnNames.count);
      if (rowIdx > 0)
      {
        [insertSQL addObject:@","];
      }
      
      [insertSQL addObject:argumentTuple];
      [flattenedValues addObjectsFromArray:row];
    }];
  }
  
  return [self executeUpdate:[insertSQL componentsJoinedByString:@" "]
        withArgumentsInArray:flattenedValues
                       error:error_p];
}

- (NSNumber *)insertInto:(NSString *)tableName
                     row:(NSDictionary *)rowValues
                   error:(NSError **)error_p
{
  NSArray * columns = rowValues.allKeys;
  NSMutableArray * values = [[NSMutableArray alloc] init];
  for (NSString * column in columns)
  {
    id value = rowValues[column];
    [values addObject:value];
  }
  
  BOOL inserted = [self insertInto:tableName
                           columns:columns
                            values:@[ values ]
                             error:error_p];
  if (!inserted)
  {
    return 0;
  }
  
  return @(self.lastInsertRowId);
}

// ========== COUNT ====================================================================================================
#pragma mark - Count

+ (NSString *)statementToCount:(NSArray *)columnNames
                          from:(NSString *)from
                         where:(NSString *)where
{
  NSMutableString * countColumn = [[NSMutableString alloc] init];
  [countColumn appendString:@"count("];
  [countColumn appendString:[FMDatabase listOfColumns:columnNames]];
  [countColumn appendString:@")"];

  return [self statementToSelect:@[ countColumn ]
                            from:from
                           where:where
                         groupBy:nil
                          having:nil
                         orderBy:nil
                           limit:nil
                          offset:nil];
}

- (NSInteger)countFrom:(NSString *)from
                 error:(NSError **)error_p
{
  return [self count:nil
                from:from
               where:nil
           arguments:nil
               error:error_p];
}

- (NSInteger)countFrom:(NSString *)from
        matchingValues:(NSDictionary *)valuesToMatch
                 error:(NSError **)error_p
{
  return [self count:nil
                from:from
      matchingValues:valuesToMatch
               error:error_p];
}

- (NSInteger)count:(NSArray *)columnNames
              from:(NSString *)from
    matchingValues:(NSDictionary *)valuesToMatch
             error:(NSError **)error_p
{
  NSArray * arguments = nil;
  NSString * where = [FMDatabase whereClauseToMatchValues:valuesToMatch
                                                arguments:&arguments];
  
  return [self count:columnNames
                from:from
               where:where
           arguments:arguments
               error:error_p];
}

- (NSInteger)count:(NSArray *)columnNames
              from:(NSString *)from
             where:(NSString *)where
         arguments:(NSArray *)arguments
             error:(NSError **)error_p
{
  NSString * countSQL = [FMDatabase statementToCount:columnNames
                                                from:from
                                               where:where];
  
  FMResultSet * results = [self executeQuery:countSQL
                        withArgumentsInArray:arguments];
  if (results == nil)
  {
    return -1;
  }
  else if ([results next])
  {
    if (sizeof(NSInteger) == sizeof(long))
    {
      return [results longForColumnIndex:0];
    }
    else
    {
      return [results intForColumnIndex:0];
    }
  }
  else
  {
    return 0;
  }
}

// ========== SELECT ===================================================================================================
#pragma mark - Select

- (NSArray *)selectAllFrom:(NSString *)tableName
                   orderBy:(NSString *)orderBy
                     error:(NSError **)error_p
{
  return [self selectResults:nil
                        from:tableName
                       where:nil
                     groupBy:nil
                      having:nil
                   arguments:nil
                     orderBy:orderBy
                       limit:nil
                      offset:nil
                       error:error_p].allRecords;
}

- (NSArray *)selectAllFrom:(NSString *)from
                     where:(NSString *)where
                 arguments:(NSArray *)arguments
                   orderBy:(NSString *)orderBy
                     error:(NSError **)error_p
{
  return [self selectResults:nil
                        from:from
                       where:where
                     groupBy:nil
                      having:nil
                   arguments:arguments
                     orderBy:orderBy
                       limit:nil
                      offset:nil
                       error:error_p].allRecords;
}

// ---------- RESULTS --------------------------------------------------------------------------------------------------
#pragma mark Results

+ (NSString *)whereClauseToMatchValues:(NSDictionary *)valuesToMatch
                             arguments:(NSArray **)arguments_p
{
  if (valuesToMatch.count == 0)
  {
    if (arguments_p) *arguments_p = @[];
    return @"1";
  }
  
  NSMutableArray * where = [[NSMutableArray alloc] init];
  NSMutableArray * arguments  = [[NSMutableArray alloc] initWithCapacity:valuesToMatch.count];
  [valuesToMatch enumerateKeysAndObjectsUsingBlock:^(NSString * columnName, id value, BOOL *stop) {
    
    if (where.count > 0)
    {
      [where addObject:@"AND"];
    }
    
    [where addObject:[FMDatabase escapeIdentifier:columnName]];
    
    if (value == [NSNull null])
    {
      [where addObject:@"IS NULL"];
    }
    else if ([value isKindOfClass:[NSArray class]])
    {
      [where addObject:@"IN ("];
      
      BOOL isFirst = YES;
      for (id arg in value)
      {
        if (!isFirst) {
          [where addObject:@","];
        }
        [where addObject:@"?"];
        isFirst = NO;

        [arguments addObject:arg];
      }
      
      [where addObject:@")"];
    }
    else
    {
      [where addObject:@"= ?"];
      [arguments addObject:value];
    }
  }];
  
  if (arguments_p != NULL)
  {
    *arguments_p = arguments;
  }
  
  return [where componentsJoinedByString:@" "];
}

+ (NSString *)statementToSelect:(NSArray *)columnNames
                           from:(NSString *)from
                          where:(NSString *)where
                        groupBy:(NSString *)groupBy
                         having:(NSString *)having
                        orderBy:(NSString *)orderBy
                          limit:(NSNumber *)limit
                         offset:(NSNumber *)offset
{
  NSMutableArray * selectSQL = [[NSMutableArray alloc] init];
  [selectSQL addObject:@"SELECT"];
  [selectSQL addObject:[FMDatabase listOfColumns:columnNames]];
  [selectSQL addObject:@"FROM"];
  [selectSQL addObject:from];
  
  if (where.length > 0)
  {
    [selectSQL addObject:@"WHERE"];
    [selectSQL addObject:where];
  }
  
  if ([groupBy length] > 0)
  {
    [selectSQL addObject:@"GROUP BY"];
    [selectSQL addObject:groupBy];
    
    if ([having length] > 0)
    {
      [selectSQL addObject:@"HAVING"];
      [selectSQL addObject:having];
    }
  }
  
  if ([orderBy length] > 0)
  {
    [selectSQL addObject:@"ORDER BY"];
    [selectSQL addObject:orderBy];
  }
  
  if (limit != nil)
  {
    [selectSQL addObject:@"LIMIT"];
    [selectSQL addObject:limit.stringValue];
    
    if (offset != nil)
    {
      [selectSQL addObject:@"OFFSET"];
      [selectSQL addObject:offset.stringValue];
    }
  }
  
  return [selectSQL componentsJoinedByString:@" "];
}

- (FMResultSet *)selectResultsFrom:(NSString *)tableName
                           orderBy:(NSString *)orderBy
                             error:(NSError **)error_p
{
  return [self selectResults:nil
                        from:tableName
                       where:nil
                     groupBy:nil
                      having:nil
                   arguments:nil
                     orderBy:orderBy
                       limit:nil
                      offset:nil
                       error:error_p];
}

- (FMResultSet *)selectResultsFrom:(NSString *)from
                    matchingValues:(NSDictionary *)valuesToMatch
                           orderBy:(NSString *)orderBy
                             error:(NSError **)error_p
{
  return [self selectResults:nil
                        from:from
              matchingValues:valuesToMatch
                     orderBy:orderBy
                       limit:nil
                      offset:nil
                       error:error_p];
}

- (FMResultSet *)selectResults:(NSArray *)columnNames
                          from:(NSString *)from
                matchingValues:(NSDictionary *)valuesToMatch
                       orderBy:(NSString *)orderBy
                         limit:(NSNumber *)limit
                        offset:(NSNumber *)offset
                         error:(NSError **)error_p
{
  NSArray * arguments = nil;
  NSString * where = [FMDatabase whereClauseToMatchValues:valuesToMatch
                                                arguments:&arguments];
  
  return [self selectResults:columnNames
                        from:from
                       where:where
                     groupBy:nil
                      having:nil
                   arguments:arguments
                     orderBy:orderBy
                       limit:limit
                      offset:offset
                       error:error_p];
}

- (FMResultSet *)selectResultsFrom:(NSString *)tableName
                             where:(NSString *)conditions
                         arguments:(NSArray *)arguments
                           orderBy:(NSString *)orderBy
                             error:(NSError **)error_p
{
  return [self selectResults:nil
                        from:tableName
                       where:conditions
                     groupBy:nil
                      having:nil
                   arguments:arguments
                     orderBy:orderBy
                       limit:nil
                      offset:nil
                       error:error_p];
}

- (FMResultSet *)selectResults:(NSArray *)columnNames
                          from:(NSString *)from
                         where:(NSString *)where
                       groupBy:(NSString *)groupBy
                        having:(NSString *)having
                     arguments:(NSArray *)arguments
                       orderBy:(NSString *)orderBy
                         limit:(NSNumber *)limit
                        offset:(NSNumber *)offset
                         error:(NSError **)error_p
{
  NSString * selectSQL = [FMDatabase statementToSelect:columnNames
                                                  from:from
                                                 where:where
                                               groupBy:groupBy
                                                having:having
                                               orderBy:orderBy
                                                 limit:limit
                                                offset:offset];
  
  FMResultSet * results = [self executeQuery:selectSQL
                        withArgumentsInArray:arguments];
  if (results == nil && error_p != NULL)
  {
    *error_p = self.lastError;
  }
  return results;
}

// ========== UPDATE ===================================================================================================
#pragma mark - Update

- (NSInteger)update:(NSString *)tableName
             values:(NSDictionary *)values
     matchingValues:(NSDictionary *)matchingValues
              error:(NSError **)error_p
{
  NSArray * arguments = nil;
  NSString * where = [FMDatabase whereClauseToMatchValues:matchingValues
                                                arguments:&arguments];
  return [self update:tableName
               values:values
                where:where
            arguments:arguments
                error:error_p];
}

- (NSInteger)update:(NSString *)tableName
             values:(NSDictionary *)values
              where:(NSString *)where
          arguments:(NSArray *)whereArguments
              error:(NSError **)error_p
{
  NSMutableArray * allArguments = [[NSMutableArray alloc] initWithCapacity:(values.count + whereArguments.count)];
  NSMutableArray * columnNames = [[NSMutableArray alloc] init];
  NSMutableArray * expressions = [[NSMutableArray alloc] init];
  
  [values enumerateKeysAndObjectsUsingBlock:^(NSString * columnName, id obj, BOOL *stop) {
    [columnNames addObject:columnName];
    [expressions addObject:@"?"];
    [allArguments addObject:obj];
  }];
  
  if (whereArguments.count > 0)
  {
    [allArguments addObjectsFromArray:whereArguments];
  }
  
  return [self update:tableName
              columns:columnNames
          expressions:expressions
                where:where
            arguments:allArguments
                error:error_p];
}

- (NSInteger)update:(NSString *)tableName
            columns:(NSArray *)columnNames
        expressions:(NSArray *)expressions
              where:(NSString *)where
          arguments:(NSArray *)arguments
              error:(NSError **)error_p
{
  NSParameterAssert(columnNames.count > 0);
  NSParameterAssert(expressions.count == columnNames.count);
  
  NSMutableArray * updateSQL = [[NSMutableArray alloc] init];
  [updateSQL addObject:@"UPDATE"];
  [updateSQL addObject:[FMDatabase escapeIdentifier:tableName]];
  [updateSQL addObject:@"SET"];
  
  [columnNames enumerateObjectsUsingBlock:^(NSString * columnName, NSUInteger idx, BOOL *stop) {
    if (idx > 0)
    {
      [updateSQL addObject:@","];
    }
    
    [updateSQL addObject:[FMDatabase escapeIdentifier:columnName]];
    [updateSQL addObject:@"="];
    [updateSQL addObject:expressions[idx]];
  }];
  
  if (where != nil)
  {
    [updateSQL addObject:@"WHERE"];
    [updateSQL addObject:where];
  }
  
  BOOL successful = [self executeUpdate:[updateSQL componentsJoinedByString:@" "]
                   withArgumentsInArray:arguments
                                  error:error_p];
  if (!successful)
  {
    return -1;
  }
  
  return self.changes;
}


// ========== DELETE ===================================================================================================
#pragma mark - Delete

- (NSInteger)deleteFrom:(NSString *)tableName
         matchingValues:(NSDictionary *)matchingValues
                  error:(NSError **)error_p
{
  NSArray * arguments = nil;
  NSString * where = [FMDatabase whereClauseToMatchValues:matchingValues
                                                arguments:&arguments];
  return [self deleteFrom:tableName
                    where:where
                arguments:arguments
                    error:error_p];
}


- (NSInteger)deleteFrom:(NSString *)tableName
                  where:(NSString *)where
              arguments:(NSArray *)arguments
                  error:(NSError **)error_p
{
  NSMutableArray * deleteSQL = [[NSMutableArray alloc] init];
  [deleteSQL addObject:@"DELETE FROM"];
  [deleteSQL addObject:tableName];
  
  if (where.length > 0)
  {
    [deleteSQL addObject:@"WHERE"];
    [deleteSQL addObject:where];
  }
  
  BOOL succeeded = [self executeUpdate:[deleteSQL componentsJoinedByString:@" "]
                  withArgumentsInArray:arguments
                                 error:error_p];
  if (!succeeded)
  {
    return -1;
  }
  
  return self.changes;
}

@end
